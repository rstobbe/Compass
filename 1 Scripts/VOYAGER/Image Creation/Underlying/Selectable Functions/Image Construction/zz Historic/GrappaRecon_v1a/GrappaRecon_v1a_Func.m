%=====================================================
%
%=====================================================

function [GRAPPA,err] = GrappaRecon_v1a_Func(GRAPPA,INPUT)

Status2('busy','Grappa Reconstruction',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
kDat = INPUT.kDat;
GKERN = GRAPPA.GKERN;
GCDAT = GRAPPA.GCDAT;
GWCALC = GRAPPA.GWCALC;
clear INPUT;

%---------------------------------------------
% Get Grappa Kernel
%---------------------------------------------
func = str2func([GRAPPA.kernfunc,'_Func']);  
INPUT = '';
[GKERN,err] = func(GKERN,INPUT);
if err.flag
    return
end
clear INPUT;
Kern = GKERN.Kern;

%---------------------------------------------
% Get Grappa Calibration Data
%---------------------------------------------
func = str2func([GRAPPA.caldatfunc,'_Func']);  
INPUT.kDat = kDat;
[GCDAT,err] = func(GCDAT,INPUT);
if err.flag
    return
end
clear INPUT;
cDat = GCDAT.cDat;

%---------------------------------------------
% Calculate Grappa Weights
%---------------------------------------------
func = str2func([GRAPPA.wcalcfunc,'_Func']);  
INPUT.Kern = Kern;
INPUT.cDat = cDat;
[GWCALC,err] = func(GWCALC,INPUT);
if err.flag
    return
end
clear INPUT;
gi = GWCALC.gi;

%---------------------------------------------
% Grappa Reconstruct
%---------------------------------------------


%---------------------------------------------
% Return
%---------------------------------------------
GRAPPA.kDat = kDat;

Status2('done','',2);
Status2('done','',3);



