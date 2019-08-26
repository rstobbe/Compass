%=========================================================
% 
%=========================================================

function [GRD,err] = CGVisAll_v1b_Func(GRD,INPUT)

Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im0 = INPUT.Im0;
ImBase = INPUT.ImBase;
ImOff = INPUT.ImOff;
ImTest = INPUT.ImTest;
Res = INPUT.Res;
CGvec = INPUT.CGvec;

%---------------------------------------------
% Image Setup
%---------------------------------------------
Ims = 16;
Imsz = size(Im0);
Imsz = Imsz(1);
%--------
StepRatio = Imsz/2;
%--------
MSTRCT.step = ceil(StepRatio/(Ims+3)); 
MSTRCT.start = ceil((Imsz-(MSTRCT.step*Ims))/2); 
MSTRCT.stop = MSTRCT.start+(Ims-1)*MSTRCT.step;
MSTRCT.ncolumns = 4;
MSTRCT.subrows = 2;
MSTRCT.subcols = 3;
MSTRCT.slclbl = 'No';
MSTRCT.figno = '1000';
MSTRCT.dispwid = [0 max(abs(Im0(:)))*1.1];

%---------------------------------------------
% Plot Original
%---------------------------------------------
INPUT.Image = Im0;
MSTRCT.subnum = 1;
INPUT.MSTRCT = MSTRCT;
PlotMontageMulti_v1c(INPUT);
title('(1) Image From Original Data');

%---------------------------------------------
% Plot Off
%---------------------------------------------
INPUT.Image = ImOff;
MSTRCT.subnum = 2;
INPUT.MSTRCT = MSTRCT;
PlotMontageMulti_v1c(INPUT);
title('(2) Image From Sampling CG Result with B0');

%---------------------------------------------
% Plot Residual
%---------------------------------------------
INPUT.Image = Res;
MSTRCT.subnum = 3;
INPUT.MSTRCT = MSTRCT;
PlotMontageMulti_v1c(INPUT);
title('(3) Residual (2 - 1)');

%---------------------------------------------
% Plot Base
%---------------------------------------------
INPUT.Image = ImBase;
MSTRCT.subnum = 4;
INPUT.MSTRCT = MSTRCT;
PlotMontageMulti_v1c(INPUT);
title('(4) Base Image');

%---------------------------------------------
% Plot Test
%---------------------------------------------
INPUT.Image = ImTest;
MSTRCT.subnum = 5;
INPUT.MSTRCT = MSTRCT;
PlotMontageMulti_v1c(INPUT);
title('(5) Test Image');

%---------------------------------------------
% Plot Correction
%---------------------------------------------
INPUT.Image = ImTest-Im0;
MSTRCT.subnum = 6;
INPUT.MSTRCT = MSTRCT;
PlotMontageMulti_v1c(INPUT);
title('(6) Correction');

Status2('done','',2);
Status2('done','',3);


