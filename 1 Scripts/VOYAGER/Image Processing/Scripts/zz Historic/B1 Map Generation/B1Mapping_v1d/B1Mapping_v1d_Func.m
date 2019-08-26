%===========================================
% 
%===========================================

function [B1MAP,err] = B1Mapping_v1d_Func(B1MAP,INPUT)

Status('busy','Map B1');
Status2('busy','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
MAP = INPUT.MAP;
BASE = INPUT.BASE;
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
    tExpPars1 = rmfield(ExpPars1,'Sequence');
    tExpPars2 = rmfield(ExpPars2,'Sequence');    
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
    if isfield(IMG,'ImageType');
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
        if not(isfield(Array.ArrayParams,'fa'));
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
INPUT.BaseIm = BaseIm;
INPUT.ExpPars = ExpPars;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
B1Map = MAP.B1Map;

%---------------------------------------------
% B1 or Power
%---------------------------------------------
if strcmp(B1MAP.return,'Power')
    B1Map = B1Map.^2;
    B1MAP.ImageType = 'Power';
else
    B1MAP.ImageType = 'B1Map';
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
    B1MAP.name = IMG.name;
    if strfind(B1MAP.name,'.mat');
        B1MAP.name = B1MAP.name(1:end-4);
    end
    if strfind(B1MAP.name,'IMG_');
        B1MAP.name = B1MAP.name(5:end);
    end
else
    B1MAP.name = '';
end

%----------------------------------------------
% Panel Items
%----------------------------------------------
B1MAP.PanelOutput = [PanelOutput;MAP.PanelOutput];
B1MAP.ExpDisp = PanelStruct2Text(B1MAP.PanelOutput);

%----------------------------------------------
% Set Up Compass Display
%----------------------------------------------
MSTRCT.type = 'map';
MSTRCT.colour = 'Yes';
MSTRCT.dispwid = [-max(abs(B1Map(:))) max(abs(B1Map(:)))];
MSTRCT.ImInfo.pixdim = [IMG.ReconPars.ImvoxTB,IMG.ReconPars.ImvoxLR,IMG.ReconPars.ImvoxIO];
MSTRCT.ImInfo.vox = IMG.ReconPars.ImvoxTB*IMG.ReconPars.ImvoxLR*IMG.ReconPars.ImvoxIO;
MSTRCT.ImInfo.info = B1MAP.ExpDisp;
MSTRCT.ImInfo.baseorient = 'Axial';             % all images should be oriented axially
INPUT.Image = B1Map;
INPUT.MSTRCT = MSTRCT;
IMDISP = ImagingPlotSetup(INPUT);
B1MAP.IMDISP = IMDISP;

%---------------------------------------------
% Return
%---------------------------------------------
MAP = rmfield(MAP,'B1Map');
B1MAP.MAP = MAP;
B1MAP.Im = cat(4,B1Map,BaseIm);
B1MAP.ReconPars = ReconPars;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

