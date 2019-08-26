%===========================================
% 
%===========================================

function [SHIM,err] = B0ShimSiemens_v1a_Func(SHIM,INPUT)

Status2('busy','B0 Shimming',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
SCRPTipt = INPUT.SCRPTipt;
SCRPTGBL = INPUT.SCRPTGBL;
MASK = SHIM.MASK;
CAL = SHIM.CAL;
clear INPUT;

%---------------------------------------------
% Test
%--------------------------------------------- 
[~,~,comperr] = comp_struct(IMG.ReconPars,CAL.ReconPars(1),'IMG','CAL');
if not(isempty(comperr))
    err.flag = 1;
    err.msg = 'Image and Cal ReconPars do not match';
    return
end

%---------------------------------------------
% Data
%--------------------------------------------- 
te1 = IMG.ExpPars.Sequence.te1;
te2 = IMG.ExpPars.Sequence.te2;
TEdif = te2 - te1;
TEorig = te1;
Im10 = squeeze(IMG.Im(:,:,:,1,:));
Im20 = squeeze(IMG.Im(:,:,:,2,:));
Shims = IMG.FID.Shim;

%---------------------------------------------
% Fix
%---------------------------------------------
CAL.CalData(1).SphWgts = zeros(size(CAL.CalData(2).SphWgts));
CAL.CalData(1).SphWgts(1) = 1;

%---------------------------------------------
% Get Previous Shims
%---------------------------------------------
for n = 1:length(CAL.CalData)
    PrevShims(n) = Shims.(CAL.CalData(n).Shim);
    %ShimsUsed{n} = CAL.CalData(n).Shim;
    %CalVal(n) = CAL.CalData(n).CalVal;                         % Just a check
end

%---------------------------------------------
% Create Offset Map
%---------------------------------------------
[~,~,~,nrcvrs] = size(Im10); 
fMapArr = zeros(size(Im10));
for n = 1:nrcvrs
    Im1 = Im10(:,:,:,n);
    Im2 = Im20(:,:,:,n);
    AbsIm = abs(Im2);
    Mask = ones(size(AbsIm));
    Mask(AbsIm < SHIM.absthresh*max(AbsIm(:))) = NaN;
    phIm1 = angle(Im1);
    phIm2 = angle(Im2);
    dphIm = phIm2 - phIm1;
    dphIm(dphIm > pi) = dphIm(dphIm > pi) - 2*pi;
    dphIm(dphIm < -pi) = dphIm(dphIm < -pi) + 2*pi;
    fMap0 = 1000*(dphIm/(2*pi))/TEdif;    
    fMapArr(:,:,:,n) = fMap0.*Mask; 
end
fMap0 = -nanmean(fMapArr,4);                 % negative rotation

%---------------------------------------------
% Base Image for Plotting
%---------------------------------------------
BaseIm = squeeze(sum(abs(IMG.Im),4));
BaseIm = sum(abs(BaseIm),4);

%---------------------------------------------
% Mask
%---------------------------------------------
func = str2func([SHIM.maskfunc,'_Func']);  
INPUT.Im = BaseIm;                  % for now
INPUT.ReconPars = IMG.ReconPars;
INPUT.IMDISP = IMG.IMDISP;
INPUT.figno = 100;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[MASK,err] = func(MASK,INPUT);
if err.flag
    return
end
if isfield(MASK,'SCRPTipt');
    SHIM.SCRPTipt = MASK.SCRPTipt;
end
Mask = MASK.Mask;
clear INPUT;
if not(isempty(Mask))
    fMap = fMap0.*Mask;
else
    fMap = fMap0;
end

fMap(fMap > SHIM.freqthresh) = NaN;
fMap(fMap < -SHIM.freqthresh) = NaN;

%---------------------------------------------
% Create Spherical Harmonics
%---------------------------------------------
matsz = size(fMap);
[SPHs] = GenAllDeg3SphHarms4z_v1a(matsz);

%---------------------------------------------
% Regression Setup
%---------------------------------------------
Status2('busy','B0 Shimming',2);
regfunc = str2func('B0ShimSiemens_v1a_Reg');
options = optimoptions(@lsqnonlin,...
                    'Algorithm','trust-region-reflective',...
                    'Display','iter','Diagnostics','on',...
                    'FinDiffType','forward',...                  % forward    
                    'TolFun',1e-5,...
                    'TolX',1e-5);

%--- adjust for Siemens---
lb = -6000*ones(1,length(CAL.CalData));
ub = 6000*ones(1,length(CAL.CalData));

%---------------------------------------------
% Regression
%---------------------------------------------
INPUT.Im = fMap;
INPUT.SPHs = SPHs;
INPUT.CalData = CAL.CalData;
func = @(V)regfunc(V,INPUT);
V0 = ones(1,length(CAL.CalData));
[Vfit,resnorm,residual,exitflag,output,~,jacobian] = lsqnonlin(func,V0,lb,ub,options);

%--------------------------------------------
% CalData
%--------------------------------------------
for n = 1:length(CAL.CalData)
    SphWgts0(:,n) = (Vfit(n)/CAL.CalData(n).CalVal)*CAL.CalData(n).SphWgts;
end
SphWgts = sum(SphWgts0,2);

%--------------------------------------------
% Profile
%--------------------------------------------
for n = 1:17
    SPHs(:,:,:,n) = SPHs(:,:,:,n)*SphWgts(n);
end
Prof = sum(SPHs,4);

%---------------------------------------------
% Display
%---------------------------------------------
INPUT.numberslices = 15;
%INPUT.Image = cat(4,fMap0,fMap-Prof,BaseIm);
INPUT.Image = cat(4,fMap,fMap-Prof,BaseIm);
INPUT.MSTRCT.ImInfo = IMG.IMDISP.ImInfo;
[MCHRS,err] = DefaultMontageChars_v1a(INPUT);
if err.flag
    return
end
MCHRS.MSTRCT.fhand = figure;
INPUT = MCHRS;
INPUT.Name1 = 'Original';
INPUT.Name2 = 'Regression Residual';
[MOF,err] = ShimMapOverlayWithHist_v1a(INPUT);
truesize(MCHRS.MSTRCT.fhand,[350 700]);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Add to Previous Shims
%---------------------------------------------
V = PrevShims - Vfit;

%---------------------------------------------
% Write System Structure
%---------------------------------------------
NewShims = Shims;
for n = 1:length(CAL.CalData)
    NewShims.(CAL.CalData(n).Shim) = V(n);
end

%----------------------------------------------
% Naming
%----------------------------------------------
if isfield(IMG,'name')
    IMGOUT.name = IMG.name;
    if strfind(IMGOUT.name,'.mat');
        IMGOUT.name = IMGOUT.name(1:end-4);
    end
    if strfind(IMGOUT.name,'IMG_');
        IMGOUT.name = ['SHIM_',IMGOUT.name(5:end)];
    end
else
    IMGOUT.name = '';
end
IMGOUT.path = IMG.path;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',SHIM.method,'Output'};
for n = 1:length(V)
    Panel(n+2,:) = {['Update_',CAL.CalData(n).Shim],round(-Vfit(n)*10)/10,'Output'};
end
n = n+1;
Panel(n+2,:) = {'','','Output'};
N = n+2;
for n = 1:length(V)-1
    %Panel(n+N,:) = {['New_',CAL.CalData(n+1).Shim],round(V(n+1)*10)/10,'Output'};
    Panel(n+N,:) = {['New_',CAL.CalData(n+1).Shim],round(V(n+1)),'Output'};
end
% n = n+N+1;
% Panel(n+2,:) = {'','','Output'};
% N = n;
% for n = 1:length(V)-1
%     %Panel(n+N,:) = {['Original_',CAL.CalData(n+1).Shim],round(PrevShims(n+1)*10)/10,'Output'};
%     Panel(n+N,:) = {['Original_',CAL.CalData(n+1).Shim],round(PrevShims(n+1)),'Output'};
% end
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMGOUT.PanelOutput = [IMG.PanelOutput;PanelOutput];
IMGOUT.ExpDisp = PanelStruct2Text(IMGOUT.PanelOutput);

%--------------------------------------------
% Write New Shims
%--------------------------------------------
fh = figure;
for n = 1:length(V)-1
    uicontrol('Parent',fh,'Style','text','String',[CAL.CalData(n+1).Shim,':'],'HorizontalAlignment','left','Fontsize',20,'Position',[50 400-40*n 100 40]);
    uicontrol('Parent',fh,'Style','text','String',num2str(round(V(n+1))),'HorizontalAlignment','left','Fontsize',20,'Position',[180 400-40*n 100 40]);
end
uicontrol('Parent',fh,'Style','text','String','DelF:','HorizontalAlignment','left','Fontsize',20,'Position',[50 400-380 100 40]);
uicontrol('Parent',fh,'Style','text','String',num2str(round(-Vfit(1))),'HorizontalAlignment','left','Fontsize',20,'Position',[180 400-380 100 40]);

%----------------------------------------------
% Set Up Compass Display
%----------------------------------------------
MSTRCT.type = 'map';
MSTRCT.colour = 'Yes';
MSTRCT.dispwid = [-max(abs(fMap0(:))) max(abs(fMap0(:)))];
MSTRCT.ImInfo.pixdim = [IMG.ReconPars.ImvoxTB,IMG.ReconPars.ImvoxLR,IMG.ReconPars.ImvoxIO];
MSTRCT.ImInfo.vox = IMG.ReconPars.ImvoxTB*IMG.ReconPars.ImvoxLR*IMG.ReconPars.ImvoxIO;
MSTRCT.ImInfo.info = IMGOUT.ExpDisp;
MSTRCT.ImInfo.baseorient = 'Axial';             % all images should be oriented axially
INPUT.Image = fMap0;
INPUT.MSTRCT = MSTRCT;
IMDISP = ImagingPlotSetup(INPUT);

%----------------------------------------------
% Return
%----------------------------------------------
IMGOUT.Im = cat(4,fMap0,fMap,fMap-Prof,Prof,BaseIm);
IMGOUT.ExpPars = IMG.ExpPars;
IMGOUT.ReconPars = IMG.ReconPars;
IMGOUT.IMDISP = IMDISP;

SHIM.TEdif = TEdif;
SHIM.TEorig = TEorig;

if isfield(IMG,'Processing')
    Processing = IMG.Processing;
else
    Processing = cell(0);
end
Processing{length(Processing)+1} = SHIM;
IMGOUT.Processing = Processing;

SHIM.IMG = IMGOUT;
SHIM.NewShims = NewShims;

Status2('done','',2);
Status2('done','',3);
