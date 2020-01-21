%====================================================
%  
%====================================================

function [B0MAP,err] = MapB0FieldNaVarian_v1a_Func(B0MAP,INPUT)

Status2('busy','B0 Field Mapping',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
ExtRun = INPUT.ExtRun;
clear INPUT;

%---------------------------------------------
% Data
%--------------------------------------------- 
TEdif = (IMG.ExpPars.Array.ArrayParams.padel(2) - IMG.ExpPars.Array.ArrayParams.padel(1))/1000;
Im1 = squeeze(IMG.Im(:,:,:,1,:));
Im2 = squeeze(IMG.Im(:,:,:,2,:));

%---------------------------------------------
% Create Offset Map
%---------------------------------------------
AbsIm = abs((Im1+Im2)/2);
Mask = ones(size(AbsIm));
Mask(AbsIm < B0MAP.absthresh*max(AbsIm(:))) = NaN;
phIm1 = angle(Im1);
phIm2 = angle(Im2);
dphIm = phIm2 - phIm1;
dphIm(dphIm > pi) = dphIm(dphIm > pi) - 2*pi;
dphIm(dphIm < -pi) = dphIm(dphIm < -pi) + 2*pi;
B0Map = -(1000*(dphIm/(2*pi))/TEdif).*Mask;    

%---------------------------------------------
% Base Image for Plotting
%---------------------------------------------
BaseIm = AbsIm;

%---------------------------------------------
% Plot
%---------------------------------------------
INPUT.numberslices = 16;
INPUT.Image = cat(4,B0Map,BaseIm);
INPUT.MSTRCT.ImInfo = IMG.IMDISP.ImInfo;
[MCHRS,err] = DefaultMontageChars_v1a(INPUT);
if err.flag
    return
end
if strcmp(ExtRun,'Yes')
    MCHRS.MSTRCT.fhand = figure('Visible','off');
else
    MCHRS.MSTRCT.fhand = figure();
end
MCHRS.MSTRCT.fhand.Position = [400 200 1750 950];
INPUT = MCHRS;
INPUT.Name = 'B0Map';
[MOF,err] = B0mapOverlayWithHist_v1a(INPUT);
truesize(MCHRS.MSTRCT.fhand,[500 600]);

%---------------------------------------------
% Plot Compass
%---------------------------------------------
global FIGOBJS
if strcmp(ExtRun,'Yes')
    figure(FIGOBJS.Compass);
    CurTab = FIGOBJS.IM.CurrentImage;
    CurTab = CurTab + 1;
    if CurTab > 10
        CurTab = 1;
    end
    FIGOBJS.IM.CurrentImage = CurTab;
    FIGOBJS.IM.TabGroup.SelectedTab = FIGOBJS.IM.ImTab(CurTab);
    FIGOBJS.IM.DispPan(CurTab) = uipanel('Parent',FIGOBJS.IM.ImTab(CurTab));
    FIGOBJS.IM.DispPan(CurTab).Position = [0.01 0.01 0.98 0.98];
    FIGOBJS.IM.DispPan(CurTab).HitTest = 'off';
    MCHRS.MSTRCT.fhand = FIGOBJS.IM.DispPan(CurTab);
    INPUT = MCHRS;
    INPUT.Name = 'B0Map';
    [~,err] = B0mapOverlayWithHist_v1a(INPUT);
    if err.flag
        return
    end
    clear INPUT;
end

%----------------------------------------------
% Naming
%----------------------------------------------
if isfield(IMG,'name')
    B0IMG.name = IMG.name;
    if strfind(B0IMG.name,'.mat')
        B0IMG.name = B0IMG.name(1:end-4);
    end
    if strfind(B0IMG.name,'IMG_')
        B0IMG.name = ['B0MAP_',B0IMG.name(5:end)];
    end
else
    B0IMG.name = '';
end
B0IMG.path = IMG.path;

%----------------------------------------------
% Panel Items
%----------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',B0MAP.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
B0IMG.PanelOutput = PanelOutput;
B0IMG.ExpDisp = PanelStruct2Text(B0IMG.PanelOutput);

%----------------------------------------------
% Set Up Compass Display
%----------------------------------------------
MSTRCT.type = 'map';
MSTRCT.colour = 'Yes';
MSTRCT.dispwid = [-max(abs(B0Map(:))) max(abs(B0Map(:)))];
MSTRCT.ImInfo.pixdim = [IMG.ReconPars.ImvoxTB,IMG.ReconPars.ImvoxLR,IMG.ReconPars.ImvoxIO];
MSTRCT.ImInfo.vox = IMG.ReconPars.ImvoxTB*IMG.ReconPars.ImvoxLR*IMG.ReconPars.ImvoxIO;
MSTRCT.ImInfo.info = B0IMG.ExpDisp;
MSTRCT.ImInfo.baseorient = 'Axial';             % all images should be oriented axially
INPUT.Image = B0Map;
INPUT.MSTRCT = MSTRCT;
IMDISP = ImagingPlotSetup(INPUT);
B0IMG.IMDISP = IMDISP;

%---------------------------------------------
% Return
%---------------------------------------------
B0IMG.Im = B0Map;
B0IMG.ReconPars = IMG.ReconPars;
B0IMG.ExpPars = IMG.ExpPars;
B0MAP.IMG = B0IMG;
B0MAP.IMG.Figure = MOF.Figure;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
