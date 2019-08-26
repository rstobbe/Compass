%===========================================
% 
%===========================================

function [DISP,err] = DisplayB0Map_v1c_Func(DISP,INPUT)

Status2('busy','Display B0 Map',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
Im1 = INPUT.Im1;
Im2 = INPUT.Im2;
Map = INPUT.Map;
ICHRS = DISP.ICHRS;
FCHRS = DISP.FCHRS;
CRTE = DISP.CRTE;
clear INPUT;

%---------------------------------------------
% Images
%---------------------------------------------
BaseIm = abs((Im1+Im2)/2);
Im = cat(4,BaseIm,Map);

%----------------------------------------------
% ImageChars
%----------------------------------------------
func = str2func([DISP.imcharsfunc,'_Func']);  
INPUT.Image = Im;
INPUT.MSTRCT = struct();
[ICHRS,err] = func(ICHRS,INPUT);
if err.flag
    return
end
clear INPUT;
Image = ICHRS.Image;
MSTRCT = ICHRS.MSTRCT;

%----------------------------------------------
% FigureChars
%----------------------------------------------
func = str2func([DISP.figcharsfunc,'_Func']);  
INPUT.MSTRCT = MSTRCT;
[FCHRS,err] = func(FCHRS,INPUT);
if err.flag
    return
end
clear INPUT;
MSTRCT = FCHRS.MSTRCT;

%----------------------------------------------
% Plot
%----------------------------------------------
func = str2func([DISP.createfunc,'_Func']);  
INPUT.Image = Image;
INPUT.MSTRCT = MSTRCT;
[CRTE,err] = func(CRTE,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Histogram (full)
%---------------------------------------------
test = Map(:);
test = test(not(isnan(test)));
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