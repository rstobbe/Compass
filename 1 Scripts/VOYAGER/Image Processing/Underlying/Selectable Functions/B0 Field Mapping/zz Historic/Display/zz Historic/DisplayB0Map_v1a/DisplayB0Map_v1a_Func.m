%===========================================
% 
%===========================================

function [DISP,err] = DisplayB0Map_v1a_Func(DISP,INPUT)

Status2('done','Display B0Map',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
AbsIm = INPUT.AbsIm;
BaseMask = INPUT.BaseMask;
fMap = INPUT.fMap;
PLOT = DISP.PLOT;
clear INPUT;

%---------------------------------------------
% Plot B0 Map
%---------------------------------------------
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.Im = AbsIm.*BaseMask;
INPUT.fMap = fMap.*BaseMask;
INPUT.dispwid = DISP.wid;
INPUT.orient = DISP.orient;
INPUT.inset = DISP.inset;
INPUT.disptype = 'DualDispwMask';
INPUT.figno = 1000;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;
title('Resonance Map (Hz)');

%---------------------------------------------
% Histogram (full)
%---------------------------------------------
test = fMap(:).*BaseMask(:);
test = test(not(isnan(test)));
test = -test;       % neg sense rotation
figure(2000); hold on;
[nels,cens] = hist(test,1000);
nels = smooth(nels,5,'moving');
plot(cens,nels,'b');
xlabel('Resonance (Hz)'); ylabel('Voxels');
title('Resonance Histogram');

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);

