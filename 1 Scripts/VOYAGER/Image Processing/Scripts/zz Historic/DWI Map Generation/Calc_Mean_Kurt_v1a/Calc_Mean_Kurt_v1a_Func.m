%=========================================================
% 
%=========================================================

function [OUTPUT,err] = Calc_Mean_Kurt_v1a_Func(INPUT,KURT)

Status('busy','Calculate Mean Kurtosis');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
LOAD = INPUT.LOAD;
CALC = INPUT.CALC;
clear INPUT

%---------------------------------------------
% Load Image
%---------------------------------------------
func = str2func([KURT.loadmeth,'_Func']);
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
% Calculate Image
%---------------------------------------------
func = str2func([KURT.calcmeth,'_Func']);
INPUT.IMG = IMG;
[CALC,err] = func(CALC,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% 
%---------------------------------------------
OUTPUT.MK = CALC.MK;
OUTPUT.MD = CALC.MD;
OUTPUT.CstrMat = CALC.CstrMat;
CALC = rmfield(CALC,{'MK','MD','CstrMat'});
OUTPUT.CALC = CALC;

Status('done','');
Status2('done','',2);
Status2('done','',3);
