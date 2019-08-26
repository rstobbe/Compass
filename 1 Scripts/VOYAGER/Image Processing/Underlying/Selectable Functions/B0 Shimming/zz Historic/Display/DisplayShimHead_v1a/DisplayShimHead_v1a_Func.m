%===========================================
% 
%===========================================

function [DISP,err] = DisplayShimHead_v1a_Func(DISP,INPUT)

Status('busy','Display Shims');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
AbsIm = INPUT.AbsIm;
fMap1 = INPUT.fMap1;
fMap2 = INPUT.fMap2;
Mask = INPUT.Mask;
Prof = INPUT.Prof;
PLOT = DISP.PLOT;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if size(fMap1) == 1
    err.flag = 1;
    err.msg = 'Incompatible Display Function';
    return
end

%---------------------------------------------
% Plot Full (Wide BW) Original B0 Map
%---------------------------------------------
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.Im = AbsIm;
INPUT.fMap = fMap1;
INPUT.dispwid = DISP.dispfullwid;
INPUT.orient = DISP.orient;
INPUT.inset = DISP.inset;
INPUT.disptype = 'DualDispwMask';
INPUT.figno = 1000;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
fulldispwid = PLOT.dispwid;
clear INPUT;
title('Full (Wide BW) Original B0 Map');

%---------------------------------------------
% Plot Full (Wide BW) Fitted B0 Map
%---------------------------------------------
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.Im = AbsIm;
INPUT.fMap = fMap1-Prof;
INPUT.dispwid = num2str(fulldispwid);
INPUT.orient = DISP.orient;
INPUT.inset = DISP.inset;
INPUT.disptype = 'DualDispwMask';
INPUT.figno = 1001;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;
title('Full (Wide BW) Fitted B0 Map');

%---------------------------------------------
% Histogram Full (Wide BW) Original B0 Map
%---------------------------------------------
test = fMap1(:);
test = test(not(isnan(test)));
test = -test;       % neg sense rotation
figure(1002); hold on;
[nels,censW] = hist(test,1000);
nels = smooth(nels,5,'moving');
plot(censW,nels,'b');
xlabel('Off Resonance (Hz)'); ylabel('Voxels');
title('Full (Wide BW) Histogram');

%---------------------------------------------
% Histogram Full (Wide BW) Fitted B0 Map
%---------------------------------------------
test = fMap1(:)-Prof(:);
test = test(not(isnan(test)));
test = -test;       % neg sense rotation
figure(1002); hold on;
[nels,censW] = hist(test,censW);
nels = smooth(nels,5,'moving');
plot(censW,nels,'r');

%======================================================

%---------------------------------------------
% Plot Masked (Narrow BW) Original B0 Map
%---------------------------------------------
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.Im = AbsIm;
INPUT.fMap = fMap2.*Mask;
INPUT.dispwid = DISP.dispmaskwid;
INPUT.orient = DISP.orient;
INPUT.inset = DISP.inset;
INPUT.disptype = 'DualDispwMask';
INPUT.figno = 2000;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
maskdispwid = PLOT.dispwid;
clear INPUT;
title('Masked (Narrow BW) Original B0 Map');

%---------------------------------------------
% Plot Masked (Narrow BW) Original B0 Map
%---------------------------------------------
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.Im = AbsIm;
INPUT.fMap = (fMap2-Prof).*Mask;
INPUT.dispwid = num2str(maskdispwid);
INPUT.orient = DISP.orient;
INPUT.inset = DISP.inset;
INPUT.disptype = 'DualDispwMask';
INPUT.figno = 2001;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;
title('Masked (Narrow BW) Fitted B0 Map');

%---------------------------------------------
% Histogram Masked (Narrow BW) Original B0 Map
%---------------------------------------------
test = fMap2(:).*Mask(:);
test = test(not(isnan(test)));
test = -test;       % neg sense rotation
figure(2002); hold on;
[nels,censN] = hist(test,1000);
nels = smooth(nels,5,'moving');
plot(censN,nels,'b');
xlabel('Off Resonance (Hz)'); ylabel('Voxels');
title('Masked (Narrow BW) Histogram');

%---------------------------------------------
% Histogram Masked (Narrow BW) Fitted B0 Map
%---------------------------------------------
test = (fMap2(:)-Prof(:)).*Mask(:);
test = test(not(isnan(test)));
test = -test;       % neg sense rotation
figure(2002); hold on;
[nels,censN] = hist(test,censN);
nels = smooth(nels,5,'moving');
plot(censN,nels,'r');

%---------------------------------------------
% Return
%---------------------------------------------

Status2('done','',2);
Status2('done','',3);

