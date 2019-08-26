%===========================================
% 
%===========================================

function [DISP,err] = DisplayShim2TE_v1c_Func(DISP,INPUT)

Status2('busy','Display Shim',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
AbsIm = INPUT.AbsIm;
fMap = INPUT.fMap;
Mask = INPUT.Mask;
Prof = INPUT.Prof;
ICHRS = DISP.ICHRS;
FCHRS = DISP.FCHRS;
CRTE = DISP.CRTE;
clear INPUT;

%---------------------------------------------
% Join Images
%---------------------------------------------
if not(isempty(Mask))
    Im = cat(4,AbsIm,fMap,Prof,fMap-Prof);
else
    Im = cat(4,AbsIm,fMap,Prof,fMap-Prof,Mask);
end
    
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

%---------------------------------------------
% Plot Full Original B0 Map
%---------------------------------------------
func = str2func([DISP.createfunc,'_Func']);  
INPUT.Image = Image(:,:,:,[1,2]);
INPUT.MSTRCT = MSTRCT;
[CRTE,err] = func(CRTE,INPUT);
if err.flag
    return
end
title('Full Original B0 Map');

%---------------------------------------------
% Histogram (full)
%---------------------------------------------
test = Map(:);
test = test(not(isnan(test)));
figure(2000); hold on;
[nels,cens] = hist(test,1000);
nels = smooth(nels,5,'moving');
plot(cens,nels,'b');
xlabel('ASC [mM]'); ylabel('Voxels');
title('Concentration Histogram');

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);