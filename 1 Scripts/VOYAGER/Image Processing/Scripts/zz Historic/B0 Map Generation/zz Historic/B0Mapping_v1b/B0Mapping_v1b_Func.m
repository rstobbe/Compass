%===========================================
% 
%===========================================

function [B0MAP,err] = B0Mapping_v1b_Func(B0MAP,INPUT)

Status('busy','Map B0');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
MAP = INPUT.MAP;
DISP = INPUT.DISP;
clear INPUT;

%---------------------------------------------
% Sort Out Input
%---------------------------------------------
type = 1;
if isfield(IMG.ExpPars,'Array')
    if isfield(IMG.ExpPars.Array,'padel')
        type = 2;
    else
        error();  % not supported
    end
end
if type == 1
    if iscell(IMG)
        Im1 = IMG{1}.Im;
        Im2 = IMG{2}.Im;
        TEdif = IMG{2}.ExpPars.Sequence.te - IMG{1}.ExpPars.Sequence.te;
        TEorig = IMG{1}.ExpPars.Sequence.te;
        ReconPars = IMG{1}.ReconPars;           % assume the same...
        PanelOutput = IMG{1}.PanelOutput;
    else
        Im = IMG.Im;
        Im1 = squeeze(Im(:,:,:,1,:));
        Im2 = squeeze(Im(:,:,:,2,:));
        TEdif = IMG.ExpPars.te2 - IMG.ExpPars.te1;
        TEorig = ExpPars.te1;
        ReconPars = IMG.ReconPars;
        PanelOutput = IMG.PanelOutput;
    end 
elseif type == 2
    Im = IMG.Im;
    Im1 = squeeze(Im(:,:,:,1,:));
    Im2 = squeeze(Im(:,:,:,2,:));
    TEdif = (IMG.ExpPars.Array.padel(2) - IMG.ExpPars.Array.padel(1))/1000;
    TEorig = IMG.ExpPars.Sequence.te1;
    ReconPars = IMG.ReconPars;
    PanelOutput = IMG.PanelOutput;
end

%---------------------------------------------
% B0 Map
%---------------------------------------------
func = str2func([B0MAP.mapfunc,'_Func']);  
INPUT.Im1 = Im1;
INPUT.Im2 = Im2;
INPUT.TEdif = TEdif;
INPUT.TEorig = TEorig;
INPUT.ReconPars = ReconPars;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
fMap = -MAP.fMap;

%---------------------------------------------
% Display
%---------------------------------------------
func = str2func([B0MAP.dispfunc,'_Func']);  
INPUT.Im1 = Im1;
INPUT.Im2 = Im2;
INPUT.Map = fMap;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
B0MAP.Im = fMap;
B0MAP.ReconPars = ReconPars;
B0MAP.TEdif = TEdif;
B0MAP.TEorig = TEorig;
B0MAP.PanelOutput = PanelOutput;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

