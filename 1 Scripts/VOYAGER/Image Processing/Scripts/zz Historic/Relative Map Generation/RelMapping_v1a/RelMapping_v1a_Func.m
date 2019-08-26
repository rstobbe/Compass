%===========================================
% 
%===========================================

function [RMAP,err] = RelMapping_v1a_Func(RMAP,INPUT)

Status('busy','Relative Image Map');
Status2('busy','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
RESZ = INPUT.RESZ;
MAP = INPUT.MAP;
DISP = INPUT.DISP;
clear INPUT;

%---------------------------------------------
% Sort Out Input
%---------------------------------------------
if iscell(IMG)
    if length(IMG)~= 2
        err.flag = 1;
        err.msg = 'Load 2 Images';
        return
    end
    IMG1 = IMG{1};
    IMG2 = IMG{2};
    if isfield(IMG1,'ImageType')
        if not(strcmp(IMG1.ImageType,'Image')) || not(strcmp(IMG2.ImageType,'Image'))
            err.flag = 1;
            err.msg = 'Both Files Should be an Images';
            return
        end
    end
    if isfield(IMG1,'ReconPars')
        ReconPars1 = IMG1.ReconPars;
    else
        ReconPars1 = [];
    end
    Im1 = IMG1.Im;
    if isfield(IMG2,'ReconPars')
        ReconPars2 = IMG2.ReconPars;
    else
        ReconPars2 = [];
    end
    Im2 = IMG2.Im;  
else
    error;      % not supported yet
end

%---------------------------------------------
% Resize Images If Needed
%---------------------------------------------
if not(isempty(ReconPars1) || isempty(ReconPars2))
    func = str2func([RMAP.resizefunc,'_Func']);  
    INPUT.ReconPars0 = ReconPars2;
    INPUT.ReconPars1 = ReconPars1;
    INPUT.Im = Im2;
    [RESZ,err] = func(RESZ,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    Im2 = RESZ.Im;
end

%---------------------------------------------
% Array
%--------------------------------------------- 
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

%---------------------------------------------
% Relative Map
%---------------------------------------------
func = str2func([RMAP.mapfunc,'_Func']);  
INPUT.Image = Im;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
Im = MAP.Im;

%---------------------------------------------
% Display
%---------------------------------------------
func = str2func([RMAP.dispfunc,'_Func']);  
INPUT.Im = Im;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
RMAP.Im = Im;
RMAP.ReconPars = ReconPars1;
RMAP.ExpDisp = [];

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

