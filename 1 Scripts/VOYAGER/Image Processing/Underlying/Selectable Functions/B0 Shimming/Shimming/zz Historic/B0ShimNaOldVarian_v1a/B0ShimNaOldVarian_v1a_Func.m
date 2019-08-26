%===========================================
% 
%===========================================

function [SHIM,err] = B0ShimNaOldVarian_v1a_Func(SHIM,INPUT)

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
% [~,~,comperr] = comp_struct(IMG.ReconPars,CAL.ReconPars(1),'IMG','CAL');
% if not(isempty(comperr))
%     err.flag = 1;
%     err.msg = 'Image and Cal ReconPars do not match';
%     return
% end

%---------------------------------------------
% Data
%--------------------------------------------- 
TEdif = (IMG.ExpPars.Array.ArrayParams.padel(2) - IMG.ExpPars.Array.ArrayParams.padel(1))/1000;
TEorig = IMG.ExpPars.Array.ArrayParams.padel(1)/1000;
Im1 = squeeze(IMG.Im(:,:,:,1,:));
Im2 = squeeze(IMG.Im(:,:,:,2,:));
Shims = IMG.FID.Shim;

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
AbsIm = abs((Im1+Im2)/2);
Mask = ones(size(AbsIm));
Mask(AbsIm < SHIM.absthresh*max(AbsIm(:))) = NaN;
phIm1 = angle(Im1);
phIm2 = angle(Im2);
dphIm = phIm2 - phIm1;
dphIm(dphIm > pi) = dphIm(dphIm > pi) - 2*pi;
dphIm(dphIm < -pi) = dphIm(dphIm < -pi) + 2*pi;
fMap0 = -(1000*(dphIm/(2*pi))/TEdif).*Mask;    

%---------------------------------------------
% Base Image for Plotting
%---------------------------------------------
BaseIm = AbsIm;

%---------------------------------------------
% Mask
%---------------------------------------------
func = str2func([SHIM.maskfunc,'_Func']);  
INPUT.Im = BaseIm;   
INPUT.ReconPars = IMG.ReconPars;
INPUT.IMDISP = IMG.IMDISP;
INPUT.figno = 100;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[MASK,err] = func(MASK,INPUT);
if err.flag
    return
end
if isfield(MASK,'SCRPTipt')
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
regfunc = str2func('B0ShimNaOldVarian_v1a_Reg');
options = optimoptions(@lsqnonlin,...
                    'Algorithm','trust-region-reflective',...
                    'Display','iter','Diagnostics','on',...
                    'FinDiffType','forward',...                  % forward    
                    'DiffMinChange',0.001,...                    % 0.01 (0.025)
                    'TolFun',1e-2,...
                    'TolX',1e-2);
lb = -32000*ones(1,length(CAL.CalData)) + PrevShims;
ub = 32000*ones(1,length(CAL.CalData)) + PrevShims;

%---------------------------------------------
% Regression
%---------------------------------------------
INPUT.Im = fMap;
INPUT.SPHs = SPHs;
INPUT.CalData = CAL.CalData;
func = @(V)regfunc(V,INPUT);
V0 = 10*ones(1,length(CAL.CalData));
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
%--
INPUT.Image = flip(INPUT.Image,3);                          % for old recon
%--
INPUT.MSTRCT.ImInfo = IMG.IMDISP.ImInfo;
[MCHRS,err] = DefaultMontageChars_v1a(INPUT);
if err.flag
    return
end
MCHRS.MSTRCT.fhand = figure;
MCHRS.MSTRCT.fhand.Position = [200 200 1750 934];
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
Vfit = -round(Vfit);
for n = 1:length(Vfit)
    NewShims(n) = Shims.(CAL.CalData(n).Shim) + Vfit(n);
end

%----------------------------------------------
% Naming
%----------------------------------------------
if isfield(IMG,'name')
    IMGOUT.name = IMG.name;
    if strfind(IMGOUT.name,'.mat')
        IMGOUT.name = IMGOUT.name(1:end-4);
    end
    if strfind(IMGOUT.name,'IMG_')
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
for n = 1:length(NewShims)
    Panel(n+2,:) = {['Update_',CAL.CalData(n).Shim],Vfit(n),'Output'};
end
n = n+1;
Panel(n+2,:) = {'','','Output'};
N = n+2;
for n = 1:length(NewShims)
    Panel(n+N,:) = {['New_',CAL.CalData(n).Shim],NewShims(n),'Output'};
end
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMGOUT.PanelOutput = [IMG.PanelOutput;PanelOutput];
IMGOUT.ExpDisp = PanelStruct2Text(IMGOUT.PanelOutput);

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

%-------------------------------------------------
% Write Parameter File
%-------------------------------------------------
fid = fopen('V:\sodium\vnmrsys\shims\shimRWS','w+');
for n = 1:length(NewShims)
    if strcmp(CAL.CalData(n).Shim,'x')
        CAL.CalData(n).Shim = 'x1';
    elseif strcmp(CAL.CalData(n).Shim,'y')
        CAL.CalData(n).Shim = 'y1';
    end
    fprintf(fid,[CAL.CalData(n).Shim,' 7 1 19 19 19 2 1 8192 1 64\n']);
    fprintf(fid,['1 ',num2str(NewShims(n)),'\n']);
    fprintf(fid,'0\n');
end
fclose(fid);

%----------------------------------------------
% Return
%----------------------------------------------
IMGOUT.Im = cat(4,fMap0,fMap,fMap-Prof,Prof,BaseIm);
IMGOUT.ExpPars = IMG.ExpPars;
IMGOUT.ReconPars = IMG.ReconPars;
IMGOUT.IMDISP = IMDISP;

SHIM.TEdif = TEdif;
SHIM.TEorig = TEorig;
SHIM.NewShims = NewShims;

if isfield(IMG,'Processing')
    Processing = IMG.Processing;
else
    Processing = cell(0);
end
Processing{length(Processing)+1} = SHIM;
IMGOUT.Processing = Processing;

SHIM.IMG = IMGOUT;

Status2('done','',2);
Status2('done','',3);
