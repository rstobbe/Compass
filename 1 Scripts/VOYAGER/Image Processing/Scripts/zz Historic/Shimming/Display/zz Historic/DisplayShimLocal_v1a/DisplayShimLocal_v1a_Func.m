%===========================================
% 
%===========================================

function [DISP,err] = DisplayShim_v1a_Func(DISP,INPUT)

Status('busy','Display Shims');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
SHIM = INPUT.SHIM;
PLOT = INPUT.PLOT;
clear INPUT;

%---------------------------------------------
% Plot Full B0 Map
%---------------------------------------------
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.Im = SHIM.AbsIm.*SHIM.BaseMask;
INPUT.fMap = SHIM.fMap.*SHIM.BaseMask;
INPUT.dispwid = DISP.disporigfullwid;
INPUT.orient = DISP.orient;
INPUT.inset = DISP.inset;
INPUT.disptype = 'DualDispwMask';
INPUT.figno = 1000;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;
title('Full Original B0 Map');

%---------------------------------------------
% Plot Masked B0 Map
%---------------------------------------------
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.Im = SHIM.AbsIm.*SHIM.BaseMask;
INPUT.fMap = SHIM.fMap.*SHIM.Mask;
INPUT.dispwid = DISP.disporigmaskwid;
INPUT.orient = DISP.orient;
INPUT.inset = DISP.inset;
INPUT.disptype = 'DualDispwMask';
INPUT.figno = 1001;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;
title('Masked Original B0 Map');

%---------------------------------------------
% Histogram (full)
%---------------------------------------------
test = SHIM.fMap(:).*SHIM.BaseMask(:);
test = test(not(isnan(test)));
test = -test;       % neg sense rotation
figure(2000); hold on;
[nels,cens] = hist(test,1000);
%plot(cens,nels);
nels = smooth(nels,5,'moving');
plot(cens,nels,'b');
xlabel('Off Resonance (Hz)'); ylabel('Voxels');
title('Full Histogram');

%---------------------------------------------
% Histogram
%---------------------------------------------
test = SHIM.fMap(:).*SHIM.Mask(:);
test = test(not(isnan(test)));
test = -test;       % neg sense rotation
figure(2001); hold on;
[nels,cens] = hist(test,1000);
%plot(cens,nels);
nels = smooth(nels,5,'moving');
plot(cens,nels,'b');
xlabel('Off Resonance (Hz)'); ylabel('Voxels');
title('Masked Histogram');

%---------------------------------------------
% Plot Full B0 Map
%---------------------------------------------
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.Im = SHIM.AbsIm.*SHIM.BaseMask;
INPUT.fMap = (SHIM.fMap-SHIM.Prof).*SHIM.BaseMask;
INPUT.dispwid = DISP.disporigfullwid;
INPUT.orient = DISP.orient;
INPUT.inset = DISP.inset;
INPUT.disptype = 'DualDispwMask';
INPUT.figno = 1002;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;
title('Full Fitted B0 Map');

%---------------------------------------------
% Plot Masked B0 Map
%---------------------------------------------
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.Im = SHIM.AbsIm.*SHIM.BaseMask;
INPUT.fMap = (SHIM.fMap-SHIM.Prof).*SHIM.Mask;
INPUT.dispwid = DISP.dispfitmaskwid;
INPUT.orient = DISP.orient;
INPUT.inset = DISP.inset;
INPUT.disptype = 'DualDispwMask';
INPUT.figno = 1003;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;
title('Masked Fitted B0 Map');

%---------------------------------------------
% Histogram (full)
%---------------------------------------------
test = (SHIM.fMap(:)-SHIM.Prof(:)).*SHIM.BaseMask(:);
test = test(not(isnan(test)));
test = -test;       % neg sense rotation
figure(2000); hold on;
[nels,cens] = hist(test,1000);
%plot(cens,nels);
nels = smooth(nels,5,'moving');
plot(cens,nels,'r');
xlabel('Off Resonance (Hz)'); ylabel('Voxels');

%---------------------------------------------
% Histogram
%---------------------------------------------
test = (SHIM.fMap(:)-SHIM.Prof(:)).*SHIM.Mask(:);
test = test(not(isnan(test)));
test = -test;       % neg sense rotation
figure(2001); hold on;
[nels,cens] = hist(test,1000);
%plot(cens,nels);
nels = smooth(nels,5,'moving');
plot(cens,nels,'r');
xlabel('Off Resonance (Hz)'); ylabel('Voxels');

%---------------------------------------------
% Return
%---------------------------------------------

Status2('done','',2);
Status2('done','',3);

