%===========================================
% 
%===========================================

function [B0MAP,err] = B0MapMultiImage_v1a_Func(B0MAP,INPUT)

Status2('busy','B0 Mapping',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG;
clear INPUT;

%---------------------------------------------
% Test
%--------------------------------------------- 
if length(IMG) ~= 2
    err.flag = 1;
    err.msg = 'B0MapMultiImage requires 2 input images';
    return
end

%---------------------------------------------
% Data
%--------------------------------------------- 
te1 = IMG{1}.ExpPars.Sequence.te;
te2 = IMG{2}.ExpPars.Sequence.te;
TEdif = te2 - te1;
TEorig = te1;
Im10 = squeeze(IMG{1}.Im);
Im20 = squeeze(IMG{2}.Im);
IMG = IMG{1};

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
    Mask(AbsIm < B0MAP.absthresh*max(AbsIm(:))) = NaN;
    phIm1 = angle(Im1);
    phIm2 = angle(Im2);
    dphIm = phIm2 - phIm1;
    dphIm(dphIm > pi) = dphIm(dphIm > pi) - 2*pi;
    dphIm(dphIm < -pi) = dphIm(dphIm < -pi) + 2*pi;
    fMap = 1000*(dphIm/(2*pi))/TEdif;    
    fMapArr(:,:,:,n) = fMap.*Mask; 
end
fMap = nanmean(fMapArr,4);

%---------------------------------------------
% Polarity
%---------------------------------------------
if strcmp(B0MAP.shimcalpol,'AbsFreq')
    fMap = fMap;
elseif strcmp(B0MAP.shimcalpol,'B0')
    fMap = -fMap;
end

%---------------------------------------------
% Base Image for Plotting
%---------------------------------------------
BaseIm = abs(Im10)+abs(Im20);

%---------------------------------------------
% Plot
%---------------------------------------------
if strcmp(B0MAP.plot,'Yes')
    INPUT.numberslices = 16;
    INPUT.Image = cat(4,fMap,BaseIm);
    INPUT.MSTRCT.ImInfo = IMG.IMDISP.ImInfo;
    [MCHRS,err] = DefaultMontageChars_v1a(INPUT);
    if err.flag
        return
    end
    MCHRS.MSTRCT.fhand = figure;
    INPUT = MCHRS;
%     if max(abs(fMap(:))) > 100
%         dispwid = [-100 100];
%         INPUT.dispwid = dispwid;
%     end
    INPUT.Name = 'B0Map';
    B0mapOverlayWithHist_v1a(INPUT);
    truesize(MCHRS.MSTRCT.fhand,[500 600]);
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
        IMGOUT.name = ['B0MAP_',IMGOUT.name(5:end)];
    end
else
    IMGOUT.name = '';
end
IMGOUT.path = IMG.path;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',B0MAP.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMGOUT.PanelOutput = [IMG.PanelOutput;PanelOutput];
IMGOUT.ExpDisp = PanelStruct2Text(IMGOUT.PanelOutput);

%----------------------------------------------
% Set Up Compass Display
%----------------------------------------------
MSTRCT.type = 'map';
MSTRCT.colour = 'Yes';
MSTRCT.dispwid = [-max(abs(fMap(:))) max(abs(fMap(:)))];
MSTRCT.ImInfo.pixdim = [IMG.ReconPars.ImvoxTB,IMG.ReconPars.ImvoxLR,IMG.ReconPars.ImvoxIO];
MSTRCT.ImInfo.vox = IMG.ReconPars.ImvoxTB*IMG.ReconPars.ImvoxLR*IMG.ReconPars.ImvoxIO;
MSTRCT.ImInfo.info = IMGOUT.ExpDisp;
MSTRCT.ImInfo.baseorient = 'Axial';             % all images should be oriented axially
INPUT.Image = fMap;
INPUT.MSTRCT = MSTRCT;
IMDISP = ImagingPlotSetup(INPUT);

%----------------------------------------------
% Return
%----------------------------------------------
IMGOUT.Im = cat(4,fMap,BaseIm);
IMGOUT.ExpPars = IMG.ExpPars;
IMGOUT.ReconPars = IMG.ReconPars;
IMGOUT.IMDISP = IMDISP;

B0MAP.TEdif = TEdif;
B0MAP.TEorig = TEorig;

if isfield(IMG,'Processing')
    Processing = IMG.Processing;
else
    Processing = cell(0);
end
Processing{length(Processing)+1} = B0MAP;
IMGOUT.Processing = Processing;

B0MAP.IMG = IMGOUT;

Status2('done','',2);
Status2('done','',3);
