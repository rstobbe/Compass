%===========================================
% 
%===========================================

function [PROCIMG,err] = GenericPostProcessing_v1a_Func(PROCIMG,INPUT)

Status('busy','Post-Process Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
IMG = INPUT.IMG;
PROC = INPUT.PROC;
DISP = INPUT.DISP;
SCRPTipt = INPUT.SCRPTipt;
SCRPTGBL = INPUT.SCRPTGBL;
clear INPUT;

%---------------------------------------------
% Sort Out Input
%---------------------------------------------
if length(IMG) > 1          
    err.flag = 1;
    err.msg = 'Do not load more than 1 image';
    return
end
IMG = IMG{1};                  

%---------------------------------------------
% Process Image
%---------------------------------------------
func = str2func([PROCIMG.procfunc,'_Func']);  
INPUT.IMG = IMG;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[PROC,err] = func(PROC,INPUT);
if err.flag
    return
end
if isfield(PROC,'SCRPTipt');
    SCRPTipt = PROC.SCRPTipt;
end
clear INPUT;
IMG = PROC.IMG;
PROC = rmfield(PROC,'IMG');
IMG.PanelOutput = [IMG.PanelOutput;PROC.PanelOutput];
if isfield(IMG,'Processing')
    Processing = IMG.Processing;
else
    Processing = cell(0);
end
Processing{length(Processing)+1} = PROC;
IMG.Processing = Processing;

%---------------------------------------------
% Display
%---------------------------------------------
func = str2func([PROCIMG.dispfunc,'_Func']);  
INPUT.Im = IMG.Im;
INPUT.Name = PROC.FigureName;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
PROCIMG.IMG = IMG;
PROCIMG.SCRPTipt = SCRPTipt;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

