%===========================================
% 
%===========================================

function [ISHIM,err] = ShimImageIntensity_v1a_Func(ISHIM,INPUT)

Status2('busy','Intensity Shim',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
Im00 = INPUT.Im;
ReconPars = INPUT.ReconPars;
FIT = ISHIM.FIT;
clear INPUT;

%-------------------------------------------
% Create Filter
%-------------------------------------------
Status2('busy','Create Filter',3);
fwidx = 2*round((ReconPars.fovx/ISHIM.profres)/2);
fwidy = 2*round((ReconPars.fovy/ISHIM.profres)/2);
fwidz = 2*round((ReconPars.fovz/ISHIM.profres)/2);
F = Kaiser_v1b(fwidx,fwidy,fwidz,ISHIM.proffilt,'unsym');
Status2('done','Create Filter',3);

%---------------------------------------------
% Low Res Image
%---------------------------------------------
Im0 = abs(Im00);
[x,y,z] = size(Im0);
kdat0 = fftshift(fftn(ifftshift(Im0)));
kdat = kdat0(x/2-fwidx/2+1:x/2+fwidx/2,y/2-fwidy/2+1:y/2+fwidy/2,z/2-fwidz/2+1:z/2+fwidz/2);
tIm = fftshift(ifftn(ifftshift(kdat.*F)));
tIm = abs(tIm);

%---------------------------------------------
% Create Uniform FoV
%---------------------------------------------
mxd = max([fwidx,fwidy,fwidz]);
Im = zeros(mxd,mxd,mxd);
Im(mxd/2-fwidx/2+1:mxd/2+fwidx/2,mxd/2-fwidy/2+1:mxd/2+fwidy/2,mxd/2-fwidz/2+1:mxd/2+fwidz/2) = tIm;


Im = abs(Im00);
mxd = 30;

%---------------------------------------------
% Scale and Mask
%---------------------------------------------
Im = Im/max(Im(:));
NaNProf = zeros(size(Im));
NaNProf(Im < 0.15) = 1;
NaNProf(Im > 0.7) = 1;
NaNProf = logical(NaNProf);
Im(NaNProf) = NaN;
Im1 = Im;

%---------------------------------------------
% Display
%---------------------------------------------
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = mxd; 
IMSTRCT.rows = floor(sqrt(mxd)+1); IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(Im1,IMSTRCT);

%---------------------------------------------
% Fit Spherical Harmonics
%---------------------------------------------
INPUT.Im = Im1;
func = str2func([ISHIM.fitfunc,'_Func']);
[FIT,err] = func(FIT,INPUT);
if err.flag
    return
end
clear INPUT    

%---------------------------------------------
% Prof
%--------------------------------------------- 
V = FIT.V
Prof = FIT.Prof;
%Prof(NaNProf) = 1;

%---------------------------------------------
% Display
%---------------------------------------------
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = mxd; 
IMSTRCT.rows = floor(sqrt(mxd)+1); IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 2001; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(Prof,IMSTRCT);

%---------------------------------------------
% Correct
%---------------------------------------------
Im = abs(Im00);
Im20 = Im./Prof;
Im20 = Im20/max(Im20(:));

%---------------------------------------------
% Display
%---------------------------------------------
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = mxd; 
IMSTRCT.rows = floor(sqrt(mxd)+1); IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 2002; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(Im20,IMSTRCT);

%---------------------------------------------
% Scale and Mask
%---------------------------------------------
Im2 = Im20;
NaNProf = zeros(size(Im));
NaNProf(Im < 0.1) = 1;
%NaNProf = logical(NaNProf);
%Im(NaNProf) = NaN;

%---------------------------------------------
% Fit Spherical Harmonics
%---------------------------------------------
INPUT.Im = Im2;
func = str2func([ISHIM.fitfunc,'_Func']);
[FIT,err] = func(FIT,INPUT);
if err.flag
    return
end
clear INPUT   

%---------------------------------------------
% Prof
%--------------------------------------------- 
V = FIT.V
Prof = FIT.Prof;
Prof(NaNProf) = 1;

%---------------------------------------------
% Display
%---------------------------------------------
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = mxd; 
IMSTRCT.rows = floor(sqrt(mxd)+1); IMSTRCT.lvl = [0.9 1.1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 3001; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(Prof,IMSTRCT);

%---------------------------------------------
% Correct
%---------------------------------------------
Im30 = Im20./FIT.Prof;
Im3 = Im30;
Im3(NaNProf) = NaN;

%---------------------------------------------
% Display
%---------------------------------------------
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = mxd; 
IMSTRCT.rows = floor(sqrt(mxd)+1); IMSTRCT.lvl = [0 2]; IMSTRCT.SLab = 0; IMSTRCT.figno = 3002; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(Im3,IMSTRCT);


%---------------------------------------------
% Return
%--------------------------------------------- 


Status2('done','',2);
Status2('done','',3);

