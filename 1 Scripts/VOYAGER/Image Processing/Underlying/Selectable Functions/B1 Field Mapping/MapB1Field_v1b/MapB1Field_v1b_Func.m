%====================================================
%  
%====================================================

function [B1MAP,err] = MapB1Field_v1b_Func(B1MAP,INPUT)

Status('busy','Map B1');
Status2('busy','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
MAPFUNC = B1MAP.MAPFUNC;
BASE = B1MAP.BASE;
ExtRun = INPUT.ExtRun;
clear INPUT;

%---------------------------------------------
% Sort Out Input
%---------------------------------------------
if iscell(IMG)
    if length(IMG) == 1
        IMG = IMG{1};
    end
end
if iscell(IMG)
    if length(IMG) ~= 2
        err.flag = 1;
        err.msg = 'Load 2 Images';
        return
    end
    IMG1 = IMG{1};
    IMG2 = IMG{2};
    IMG = IMG1;
    ReconPars1 = IMG1.ReconPars;
    if isfield(IMG1.FID,'Shim')
        Shims1 = IMG1.FID.Shim;
    else 
        Shims1 = struct();
    end
    ExpPars1 = IMG1.ExpPars;
    Im1 = IMG1.Im;
    ReconPars2 = IMG2.ReconPars;
    if isfield(IMG2.FID,'Shim')
        Shims2 = IMG2.FID.Shim;
    else
        Shims2 = struct();
    end
    ExpPars2 = IMG2.ExpPars;
    Im2 = IMG2.Im;  
    
    %----------------------------------------
    % Compare
    [~,~,comperr] = comp_struct(ReconPars1,ReconPars2,'ReconPars1','ReconPars2');
    if not(isempty(comperr))
        err.flag = 1;
        err.msg = 'Image recons do not match';
        return
    end
    ReconPars = ReconPars1;
    if isempty(Shims1) || isempty(Shims2) 
        [~,~,comperr] = comp_struct(Shims1,Shims2,'Shims1','Shims2');
        if not(isempty(comperr))
            err.flag = 1;
            err.msg = 'Image do not have the same shimming';
            return
        end
         %Shims = Shims1;
    end
    tExpPars1 = rmfield(ExpPars1,{'Sequence','scantime'});
    tExpPars2 = rmfield(ExpPars2,{'Sequence','scantime'});    
    [~,~,comperr] = comp_struct(tExpPars1,tExpPars2,'tExpPars1','tExpPars2');
    if not(isempty(comperr))
        err.flag = 1;
        err.msg = 'Images do not have the same experiment paramteres';
        return
    end
    ExpPars = ExpPars1;
    PanelOutput = IMG1.PanelOutput;
    if isfield(ExpPars1.Sequence,'flipangle')
        flipangle = [ExpPars1.Sequence.flipangle ExpPars2.Sequence.flipangle];            
    elseif isfield(ExpPars1.Sequence,'flip_angle')
        flipangle = [ExpPars1.Sequence.flip_angle ExpPars2.Sequence.flip_angle];     
    elseif isfield(ExpPars1.Sequence,'flip')        
        flipangle = [ExpPars1.Sequence.flip ExpPars2.Sequence.flip];
    end
        
    %----------------------------------------
    % Image Array   
    sz = size(Im1);
    if length(sz) == 3
        Im = zeros([sz 2]);
        Im(:,:,:,1) = Im1;
        Im(:,:,:,2) = Im2;  
    end
    if length(sz) == 4    
        Im = zeros([sz(1) sz(2) sz(3) 2 sz(4)]);
        Im(:,:,:,1,:) = Im1;
        Im(:,:,:,2,:) = Im2;
    end
    if length(sz) == 5    
        Im = zeros([sz(1) sz(2) sz(3) 2 sz(5)]);
        Im(:,:,:,1,:) = Im1;
        Im(:,:,:,2,:) = Im2;
    end        
else
    if isfield(IMG,'ImageType')
        if not(strcmp(IMG.ImageType,'Image'))
            err.flag = 1;
            err.msg = 'Input File Not Image';
            return
        end
    end
    if isfield(IMG.ExpPars,'Array')
        Array = IMG.ExpPars.Array;
        if Array.ArrLen ~= 2
            err.flag = 1;
            err.msg = 'Image Array Not Supported';
            return
        end
        if not(strcmp(Array.ArrayName,'B1Map'))
            if isempty(Array.ArrayName)
                button = questdlg('Image Array Undefined, Continue?'); 
            else
                button = questdlg(['Image Array: "',Array.ArrayName,'", Continue?']);
            end
            if not(strcmp(button,'Yes'))
                return
            end
        end
        if not(isfield(Array.ArrayParams,'fa'))
            err.flag = 1;
            err.msg = 'Image Array Not Supported';
            return
        end
        Im = IMG.Im;
        flipangle = Array.ArrayParams.fa;
        PanelOutput = IMG.PanelOutput;
        ReconPars = IMG.ReconPars;
        ExpPars = IMG.ExpPars;
        ExpDisp = IMG.ExpDisp;
        FID = IMG.FID;
    end
end

%---------------------------------------------
% Create Base Image for Display
%---------------------------------------------
func = str2func([B1MAP.baseimfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ExpPars = ExpPars;
[BASE,err] = func(BASE,INPUT);
if err.flag
    return
end
clear INPUT;
BaseIm = BASE.Im;

%---------------------------------------------
% B1 Map
%---------------------------------------------
func = str2func([B1MAP.mapfunc,'_Func']);  
INPUT.Image = Im;
INPUT.ReconPars = ReconPars;
INPUT.flipangle = flipangle;
INPUT.ExpPars = ExpPars;
[MAPFUNC,err] = func(MAPFUNC,INPUT);
if err.flag
    return
end
clear INPUT;
B1Map = MAPFUNC.B1Map;

%---------------------------------------------
% B1 or Power
%---------------------------------------------
if strcmp(B1MAP.return,'Power')
    B1Map = B1Map.^2;
    B1IMG.ImageType = 'Power';
else
    B1IMG.ImageType = 'B1Map';
end

%---------------------------------------------
% Plot
%---------------------------------------------
if strcmp(B1MAP.plot,'Yes')
    INPUT.numberslices = 16;
    INPUT.Image = cat(4,B1Map,BaseIm);
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
    INPUT.Name = 'B1Map';
    [MOF,err] = B1mapOverlayWithHist_v1a(INPUT);
    truesize(MCHRS.MSTRCT.fhand,[500 600]);
end

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
    INPUT.Name = 'B1Map';
    [~,err] = B1mapOverlayWithHist_v1a(INPUT);
    if err.flag
        return
    end
    clear INPUT;
end

%----------------------------------------------
% Naming
%----------------------------------------------
if isfield(IMG,'name')
    B1IMG.name = IMG.name;
    if strfind(B1IMG.name,'.mat')
        B1IMG.name = B1IMG.name(1:end-4);
    end
    if strfind(B1IMG.name,'IMG_')
        B1IMG.name = ['B1MAP_',B1IMG.name(5:end)];
    end
else
    B1IMG.name = '';
end
B1IMG.path = IMG.path;

%----------------------------------------------
% Panel Items
%----------------------------------------------
B1IMG.PanelOutput = [PanelOutput;MAPFUNC.PanelOutput];
B1IMG.ExpDisp = PanelStruct2Text(B1IMG.PanelOutput);

%----------------------------------------------
% Set Up Compass Display
%----------------------------------------------
MSTRCT.type = 'map';
MSTRCT.colour = 'Yes';
offset = max(abs(B1Map(:)))-1;
MSTRCT.dispwid = [1-offset 1+offset];
MSTRCT.ImInfo.pixdim = [IMG.ReconPars.ImvoxTB,IMG.ReconPars.ImvoxLR,IMG.ReconPars.ImvoxIO];
MSTRCT.ImInfo.vox = IMG.ReconPars.ImvoxTB*IMG.ReconPars.ImvoxLR*IMG.ReconPars.ImvoxIO;
MSTRCT.ImInfo.info = B1IMG.ExpDisp;
MSTRCT.ImInfo.baseorient = 'Axial';             % all images should be oriented axially
INPUT.Image = B1Map;
INPUT.MSTRCT = MSTRCT;
IMDISP = ImagingPlotSetup(INPUT);
B1IMG.IMDISP = IMDISP;

%---------------------------------------------
% Return
%---------------------------------------------
MAPFUNC = rmfield(MAPFUNC,'B1Map');
B1MAP.MAPFUNC = MAPFUNC;
if strcmp(B1MAP.output,'Map')
    B1IMG.Im = B1Map;
else
    B1IMG.Im = cat(4,B1Map,BaseIm);
end
B1IMG.ReconPars = ReconPars;
B1IMG.ExpPars = ExpPars;
B1MAP.IMG = B1IMG;
B1MAP.IMG.Figure = MOF.Figure;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
