%====================================================
%  
%====================================================

function [B1MAP,err] = B1MapAFISiemens_v1a_Func(B1MAP,INPUT)

Status2('busy','Generate B1-Map',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% Test
%--------------------------------------------- 
% - need to do tests on image to confirm useful 

%---------------------------------------------
% Data
%--------------------------------------------- 
tr1 = IMG.ExpPars.Sequence.tr1;
tr2 = IMG.ExpPars.Sequence.tr2;
flip = IMG.ExpPars.Sequence.flip;
RatTR = tr2/tr1;
AbsIms = abs(IMG.Im);

%---------------------------------------------
% Get Image Ratios
%---------------------------------------------
% - instead of masking - image profiles would be better
[x,y,z,~,~] = size(Im);
RatImArr = zeros([x,y,z,ExpPars.nrcvrs]);
for n = 1:ExpPars.nrcvrs
    mask = AbsIms(:,:,:,2,n);
    mask(mask < B1MAP.maskval*max(mask(:))) = NaN;
    mask(mask >= B1MAP.maskval*max(mask(:))) = 1;
    RatIm(:,:,:,n) = (AbsIms(:,:,:,2,n)./AbsIms(:,:,:,1,n)).*mask;
end
RatIm = nanmean(RatImArr,4);                

% INPUT.Image = RatIm;
% INPUT.MSTRCT.type = 'real';
% INPUT.MSTRCT.colour = 'Yes';
% INPUT.MSTRCT.dispwid = [0.5 1.0];
% PlotMontageImage_v1e(INPUT); 

%---------------------------------------------
% Calculate Flip Angle
%---------------------------------------------
FlipIm = acos( (RatIm.*RatTR-1)./(RatTR-RatIm) );                   % Yarnykh (2007)
B1map = FlipIm/flip;

%---------------------------------------------
% Test
%---------------------------------------------
if not(isreal(B1map));
    error();
end

%---------------------------------------------
% Base Image for Plotting
%---------------------------------------------
BaseIm = squeeze(sum(abs(IMG.Im),4));
BaseIm = sum(abs(BaseIm),4);

%---------------------------------------------
% Plot
%---------------------------------------------
if strcmp(B1MAP.plot,'Yes')
    INPUT.numberslices = 16;
    INPUT.Image = cat(4,B1map,BaseIm);
    INPUT.MSTRCT.ImInfo = IMG.IMDISP.ImInfo;
    [MCHRS,err] = DefaultMontageChars_v1a(INPUT);
    if err.flag
        return
    end
    MCHRS.MSTRCT.fhand = figure;
    INPUT = MCHRS;
    INPUT.Name = 'B1Map';
    B1mapOverlayWithHist_v1a(INPUT);
    truesize(MCHRS.MSTRCT.fhand,[500 600]);
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
        IMGOUT.name = IMGOUT.name(5:end);
    end
else
    IMGOUT.name = '';
end
IMGOUT.path = IMG.path;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',B1MAP.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMGOUT.PanelOutput = [IMG.PanelOutput;PanelOutput];
IMGOUT.ExpDisp = PanelStruct2Text(IMGOUT.PanelOutput);

%----------------------------------------------
% Set Up Compass Display
%----------------------------------------------
MSTRCT.type = 'map';
MSTRCT.colour = 'Yes';
MSTRCT.dispwid = [-max(abs(B1map(:))) max(abs(B1map(:)))];
MSTRCT.ImInfo.pixdim = [IMG.ReconPars.ImvoxTB,IMG.ReconPars.ImvoxLR,IMG.ReconPars.ImvoxIO];
MSTRCT.ImInfo.vox = IMG.ReconPars.ImvoxTB*IMG.ReconPars.ImvoxLR*IMG.ReconPars.ImvoxIO;
MSTRCT.ImInfo.info = IMGOUT.ExpDisp;
MSTRCT.ImInfo.baseorient = 'Axial';             % all images should be oriented axially
INPUT.Image = B1map;
INPUT.MSTRCT = MSTRCT;
IMDISP = ImagingPlotSetup(INPUT);

%----------------------------------------------
% Return
%----------------------------------------------
IMGOUT.Im = cat(4,B1map,BaseIm);
IMGOUT.ExpPars = IMG.ExpPars;
IMGOUT.ReconPars = IMG.ReconPars;
IMGOUT.IMDISP = IMDISP;
IMGOUT.proc = 'B1MAP_';

%B1MAP.TEdif = TEdif;
%B1MAP.TEorig = TEorig;

if isfield(IMG,'Processing')
    Processing = IMG.Processing;
else
    Processing = cell(0);
end
Processing{length(Processing)+1} = B1MAP;
IMGOUT.Processing = Processing;

B1MAP.IMG = IMGOUT;

Status2('done','',2);
Status2('done','',3);