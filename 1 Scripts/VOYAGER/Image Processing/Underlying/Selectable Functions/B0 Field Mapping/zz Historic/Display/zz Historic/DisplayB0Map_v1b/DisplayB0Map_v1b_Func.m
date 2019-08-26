%===========================================
% 
%===========================================

function [DISP,err] = DisplayB0Map_v1b_Func(DISP,INPUT)

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
ISCL = DISP.ISCL;
MSCL = DISP.MSCL;
ICHRS = DISP.ICHRS;
FCHRS = DISP.FCHRS;
PLOT = DISP.PLOT;
clear INPUT;

%-------------------------------------------------
% Get Magnitude Image For Plotting
%-------------------------------------------------
% if ExpPars.nrcvrs > 1
%     sz = size(Im1);
%     if sz(4) < ExpPars.nrcvrs+1
%         err.flag = 1;
%         err.msg = 'Reconstruct with MultiSuperAdd';
%         return
%     end
%     tIm = Im1(:,:,:,ExpPars.nrcvrs+1);
% else
%     tIm = Im1;
% end
% if strcmp(ReconPars.Filter,'None')
%     [x,y,z] = size(tIm);
%     beta = 2;
%     Filt = Kaiser_v1b(x,y,z,beta,'unsym');                  
%     tIm = fftshift(fftn(ifftshift(Filt.*fftshift(ifftn(ifftshift(tIm))))));   
% end


%----------------------------------------------
% Contrast 1
%----------------------------------------------
func = str2func([DISP.imscalefunc,'_Func']);  
INPUT.MSTRCT = struct();
INPUT.Image = (Im1+Im2)/2;
[ISCL,err] = func(ISCL,INPUT);
if err.flag
    return
end
clear INPUT;
Im1 = ISCL.Image;
MSTRCT1 = ISCL.MSTRCT;

%----------------------------------------------
% Contrast Map
%----------------------------------------------
func = str2func([DISP.mapscalefunc,'_Func']);  
INPUT.MSTRCT = struct();
INPUT.Image = Map;
[MSCL,err] = func(MSCL,INPUT);
if err.flag
    return
end
clear INPUT;
Map = MSCL.Image;
MSTRCT2 = MSCL.MSTRCT;

%----------------------------------------------
% Combine
%----------------------------------------------
[x,y,z] = size(Im1);
Image = zeros([x,y,z,2]);
Image(:,:,:,1) = Im1;
Image(:,:,:,2) = Map;
MSTRCT = MSTRCT1;
MSTRCT.dispwid1 = MSTRCT1.dispwid;
MSTRCT.dispwid2 = MSTRCT2.dispwid;
MSTRCT.type2 = MSTRCT2.type;

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
% ImageChars
%----------------------------------------------
func = str2func([DISP.imcharsfunc,'_Func']);  
INPUT.MSTRCT = MSTRCT;
INPUT.Image = Image;
[ICHRS,err] = func(ICHRS,INPUT);
if err.flag
    return
end
clear INPUT;
MSTRCT = ICHRS.MSTRCT;

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