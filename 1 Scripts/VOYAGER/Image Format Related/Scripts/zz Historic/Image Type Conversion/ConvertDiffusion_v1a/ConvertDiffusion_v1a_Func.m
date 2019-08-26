%=========================================================
% 
%=========================================================

function [OUTPUT,err] = ConvertDiffusion_v1a_Func(INPUT,CVT)

Status('busy','Convert Diffusion Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
LOAD = INPUT.LOAD;
EXPORT = INPUT.EXPORT;
clear INPUT;

%---------------------------------------------
% Load Image
%---------------------------------------------
func = str2func([CVT.loadmeth,'_Func']);
INPUT = struct();
[LOAD,err] = func(LOAD,INPUT);
if err.flag
    return
end
clear INPUT;

IMG.bvalues = LOAD.bvalues;
IMG.dimnames = LOAD.dims;
IMG.Im = LOAD.dwims;

%---------------------------------------------
% Export Image
%---------------------------------------------
func = str2func([CVT.exportmeth,'_Func']);
INPUT.IMG = IMG;
[EXPORT,err] = func(EXPORT,INPUT);
if err.flag
    return
end
clear INPUT;

OUTPUT.IMG = IMG;
OUTPUT.saveflag = EXPORT.saveflag;

Status('done','');
Status2('done','',2);
Status2('done','',3);


