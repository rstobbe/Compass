%====================================================
%  
%====================================================

function [T1MAP,err] = T1Map3FA_v1a_Func(T1MAP,INPUT)

Status2('busy','Generate T1Map',2);
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
tr = IMG.ExpPars.Sequence.tr;
flip(1) = IMG.ExpPars.Sequence.flip1;
flip(2) = IMG.ExpPars.Sequence.flip2;
flip(3) = IMG.ExpPars.Sequence.flip3;
flip = pi*flip/180;
AbsIms = abs(IMG.Im);
AbsIms = AbsIms(:,:,:,:,2);             % receiver 1 for now

mask = AbsIms;
mask(mask < T1MAP.maskval*max(mask(:))) = 0;
mask(mask >= T1MAP.maskval*max(mask(:))) = 1;


%---------------------------------------------
% T1 Fit
%---------------------------------------------
regfunc = str2func([T1MAP.method,'_Reg']);
INPUT.tr = tr;
func = @(P,t)regfunc(P,t,INPUT);

Test = AbsIms(logical(mask));
Est = [500 500];

tic
[nx,ny,nz,nexp] = size(AbsIms);
T1Map = NaN*zeros([nx,ny,nz]);
for z = [45 52 59] 
%for z = 1:nz
    for y = 1:ny
        for x = 1:nx
            if mask(x,y,z) == 1
                vals = permute(squeeze(AbsIms(x,y,z,:)),[2 1]);
                beta = nlinfit(flip,vals,func,Est);
                T1Map(x,y,z) = beta(2);   
            end       
        end
        Status2('busy',['z: ',num2str(z),'  y: ',num2str(y)],2); 
    end
end
toc

%---------------------------------------------
% Base Image for Plotting
%---------------------------------------------
BaseIm = squeeze(sum(abs(IMG.Im),4));
BaseIm = sum(abs(BaseIm),4);

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',T1MAP.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMGOUT.PanelOutput = [IMG.PanelOutput;PanelOutput];
IMGOUT.ExpDisp = PanelStruct2Text(IMGOUT.PanelOutput);

%----------------------------------------------
% Set Up Compass Display
%----------------------------------------------
MSTRCT.type = 'map';
MSTRCT.colour = 'Yes';
MSTRCT.dispwid = [0 max(abs(T1Map(:)))];
MSTRCT.ImInfo.pixdim = [IMG.ReconPars.ImvoxTB,IMG.ReconPars.ImvoxLR,IMG.ReconPars.ImvoxIO];
MSTRCT.ImInfo.vox = IMG.ReconPars.ImvoxTB*IMG.ReconPars.ImvoxLR*IMG.ReconPars.ImvoxIO;
MSTRCT.ImInfo.info = IMGOUT.ExpDisp;
MSTRCT.ImInfo.baseorient = 'Axial';             % all images should be oriented axially
INPUT.Image = T1Map;
INPUT.MSTRCT = MSTRCT;
IMDISP = ImagingPlotSetup(INPUT);
Image = cat(4,T1Map,BaseIm);

%---------------------------------------------
% Plot
%---------------------------------------------
if strcmp(T1MAP.output,'MapWithHist')
    INPUT.numberslices = 16;
    INPUT.Image = cat(4,T1Map,BaseIm);
    INPUT.MSTRCT.ImInfo = IMG.IMDISP.ImInfo;
    [MCHRS,err] = DefaultMontageChars_v1a(INPUT);
    if err.flag
        return
    end
    MCHRS.MSTRCT.fhand = figure;
    INPUT = MCHRS;
    INPUT.Name = 'T1Map';
    B1mapOverlayWithHist_v1a(INPUT);
    truesize(MCHRS.MSTRCT.fhand,[500 600]);
elseif strcmp(T1MAP.output,'CompassMontage')
    INPUT.numberslices = 20;
    INPUT.Image = cat(4,T1Map(:,:,:,1),BaseIm);
    INPUT.MSTRCT.ImInfo = IMG.IMDISP.ImInfo;
    [MCHRS,err] = DefaultMontageChars_v1a(INPUT);
    if err.flag
        return
    end
    INPUT = MCHRS;
    OUTPUT = CompassMontageDefault_v1a(INPUT);
    Image = OUTPUT.Im;
    IMDISP = OUTPUT.IMDISP;
    T1MAP.CompassDisplay = 'Yes';
elseif strcmp(T1MAP.output,'Compass')
    T1MAP.CompassDisplay = 'Yes';    
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
        IMGOUT.name = ['B1MAP_',IMGOUT.name(5:end)];
    end
else
    IMGOUT.name = '';
end
IMGOUT.path = IMG.path;

%----------------------------------------------
% Return
%----------------------------------------------
IMGOUT.Im = Image;
IMGOUT.ExpPars = IMG.ExpPars;
IMGOUT.ReconPars = IMG.ReconPars;
IMGOUT.IMDISP = IMDISP;

T1MAP.TR = tr;
T1MAP.flip = flip;

if isfield(IMG,'Processing')
    Processing = IMG.Processing;
else
    Processing = cell(0);
end
Processing{length(Processing)+1} = T1MAP;
IMGOUT.Processing = Processing;

T1MAP.IMG = IMGOUT;

Status2('done','',2);
Status2('done','',3);
