%====================================================
%  
%====================================================

function [B0MAP,err] = MapB0FieldRcvr1_v1a_Func(B0MAP,INPUT)

Status2('busy','Map B0 Field',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
MAPFUNC = B0MAP.MAPFUNC;
BASE = B0MAP.BASE;
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
    IMG0 = IMG{1};
    ReconPars0 = IMG0.ReconPars;
    if isfield(IMG0.FID,'Shim')
        Shims0 = IMG0.FID.Shim;
    else 
        Shims0 = struct();
    end
    ExpPars{1} = IMG{1}.ExpPars;
    tExpPars0 = rmfield(IMG0.ExpPars,'Sequence'); 
    Im0 = IMG0.Im;
    sz = size(Im0);
%     if length(sz) > 3
%         err.flag = 1 ;
%         err.msg = 'Multidimensional images not currently supported';
%         return
%     end
    Im = zeros([sz(1:3) 1 1 length(IMG)]);
    Im(:,:,:,:,:,1) = IMG0.Im(:,:,:,:,1);  
    for n = 2:length(IMG)
        ExpPars{n} = IMG{n}.ExpPars;
        ReconPars = IMG{n}.ReconPars;
        if isfield(IMG{n}.FID,'Shim')
            Shims = IMG{n}.FID.Shim;
        else
            Shims = struct();
        end
        %----------------------------------------
        % Compare
        %----------------------------------------
        [~,~,comperr] = comp_struct(ReconPars0,ReconPars,'ReconPars0','ReconPars');
        if not(isempty(comperr))
            err.flag = 1;
            err.msg = 'Image recons do not match';
            return
        end
        if not(isempty(Shims0)) || not(isempty(Shims))
            [~,~,comperr] = comp_struct(Shims0,Shims,'Shims0','Shims');
            if not(isempty(comperr))
                err.flag = 1;
                err.msg = 'Image do not have the same shimming';
                return
            end
        end
        tExpPars = rmfield(ExpPars{n},'Sequence');    
        [~,~,comperr] = comp_struct(tExpPars0,tExpPars,'tExpPars0','tExpPars');
        if not(isempty(comperr))
            err.flag = 1;
            err.msg = 'Images do not have the same experiment paramteres';
            return
        end
        Im(:,:,:,:,:,n) = IMG{n}.Im(:,:,:,:,1);  
    end
    IMG = IMG0;
else
    ExpPars = IMG.ExpPars;
    Im = IMG.Im;
end

%---------------------------------------------
% Create Base Image for Display
%---------------------------------------------
func = str2func([B0MAP.baseimfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ExpPars = ExpPars;
[BASE,err] = func(BASE,INPUT);
if err.flag
    return
end
clear INPUT;
BaseIm = BASE.Im;

%---------------------------------------------
% Relaxation Map
%---------------------------------------------
func = str2func([B0MAP.mapfunc,'_Func']);  
INPUT.Im = Im;
INPUT.BaseIm = BaseIm;
INPUT.ExpPars = ExpPars;
[MAPFUNC,err] = func(MAPFUNC,INPUT);
if err.flag
    return
end
clear INPUT;
Map = MAPFUNC.Map;

%----------------------------------------------
% Naming
%----------------------------------------------
if isfield(IMG,'name')
    B0IMG.name = IMG.name;
    if strfind(B0IMG.name,'.mat')
        B0IMG.name = B0IMG.name(1:end-4);
    end
    if strfind(B0IMG.name,'IMG_')
        B0IMG.name = [MAPFUNC.Heading,'_',B0IMG.name(5:end)];
    end
else
    B0IMG.name = '';
end
B0IMG.path = IMG.path;

%----------------------------------------------
% Panel Items
%----------------------------------------------
B0IMG.PanelOutput = [IMG.PanelOutput;MAPFUNC.PanelOutput];
B0IMG.ExpDisp = PanelStruct2Text(B0IMG.PanelOutput);

%----------------------------------------------
% Set Up Compass Display
%----------------------------------------------
MSTRCT.type = 'map';
MSTRCT.colour = 'Yes';
MSTRCT.dispwid = [0 10];
MSTRCT.ImInfo.pixdim = [IMG.ReconPars.ImvoxTB,IMG.ReconPars.ImvoxLR,IMG.ReconPars.ImvoxIO];
MSTRCT.ImInfo.vox = IMG.ReconPars.ImvoxTB*IMG.ReconPars.ImvoxLR*IMG.ReconPars.ImvoxIO;
MSTRCT.ImInfo.info = B0IMG.ExpDisp;
MSTRCT.ImInfo.baseorient = 'Axial';             % all images should be oriented axially
INPUT.Image = Map;
INPUT.MSTRCT = MSTRCT;
IMDISP = ImagingPlotSetup(INPUT);
B0IMG.IMDISP = IMDISP;

%---------------------------------------------
% Return
%---------------------------------------------
MAPFUNC = rmfield(MAPFUNC,'Map');
B0MAP.MAPFUNC = MAPFUNC;
B0IMG.Im = Map;
B0IMG.ReconPars = IMG.ReconPars;
B0MAP.IMG = B0IMG;
B0MAP.FigureName = 'Relaxation Map';

Status2('done','',2);
Status2('done','',3);
