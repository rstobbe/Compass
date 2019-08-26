%===========================================
% 
%===========================================

function [DISP,err] = DisplayConcMap_v1a_Func(DISP,INPUT)

Status2('busy','Display Concentration Map',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
Im = INPUT.Im;
MSCL = DISP.MSCL;
ICHRS = DISP.ICHRS;
FCHRS = DISP.FCHRS;
PLOT = DISP.PLOT;
clear INPUT;

%----------------------------------------------
% Return Contrast Limits
%----------------------------------------------
func = str2func([DISP.mapscalefunc,'_Func']);  
INPUT.MSTRCT = struct();
INPUT.Image = Im;
[MSCL,err] = func(MSCL,INPUT);
if err.flag
    return
end
clear INPUT;
Im = MSCL.Image;
MSTRCT = MSCL.MSTRCT;

%----------------------------------------------
% ImageChars
%----------------------------------------------
func = str2func([DISP.imcharsfunc,'_Func']);  
INPUT.MSTRCT = MSTRCT;
INPUT.Image = Im;
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
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.Image = Image;
INPUT.MSTRCT = MSTRCT;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Histogram (full)
%---------------------------------------------
% test = Im(:);
% test = test(not(isnan(test)));
% figure(2000); hold on;
% [nels,cens] = hist(test,25);
% nels = smooth(nels,5,'moving');
% plot(cens,nels,'b');
% xlabel('ASC [mM]'); ylabel('Voxels');
% title('Concentration Histogram');

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);

