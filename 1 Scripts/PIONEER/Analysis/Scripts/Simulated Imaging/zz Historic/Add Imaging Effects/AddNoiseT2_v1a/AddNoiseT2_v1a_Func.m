%=========================================================
% 
%=========================================================

function [IEFF,err] = AddNoiseT2_v1a_Func(INPUT)

Status('busy','Add Noise and T2');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
KSMP = INPUT.KSMP;
T2 = INPUT.T2;
NOISE = INPUT.NOISE;
IEFF = INPUT.IEFF;
clear INPUT;

%---------------------------------------------
% Add T2
%---------------------------------------------
func = str2func([IEFF.t2func,'_Func']);  
INPUT.IMP = IMP;
INPUT.KSMP = KSMP;
[T2,err] = func(T2,INPUT);
if err.flag
    return
end
clear INPUT;
KSMP.SampDat = T2.SampDat;

%---------------------------------------------
% Add Noise
%---------------------------------------------
func = str2func([IEFF.noisefunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.KSMP = KSMP;
[NOISE,err] = func(NOISE,INPUT);
if err.flag
    return
end
clear INPUT;
SampDat = NOISE.SampDat;

%---------------------------------------------
% Return
%---------------------------------------------
IEFF.SampDat = SampDat;

Status('done','');
Status2('done','',2);
Status2('done','',3);
