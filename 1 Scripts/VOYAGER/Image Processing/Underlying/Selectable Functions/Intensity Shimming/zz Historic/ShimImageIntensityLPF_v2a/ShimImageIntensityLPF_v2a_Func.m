%===========================================
% 
%===========================================

function [ISHIM,err] = ShimImageIntensityLPF_v2a_Func(ISHIM,INPUT)

Status2('busy','Intensity Shim',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
Im0 = abs(INPUT.Im);
ReconPars = INPUT.ReconPars;
clear INPUT;

%---------------------------------------------
% Display
%---------------------------------------------
Im0 = Im0/max(Im0(:));
[x0,y0,z0] = size(Im0);
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = z0; 
IMSTRCT.rows = floor(sqrt(z0)+1); IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(Im0,IMSTRCT);

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
% Isotropic Low Res Image
%---------------------------------------------
kdat0 = fftshift(fftn(ifftshift(Im0)));
kdat = kdat0(x0/2-fwidx/2+1:x0/2+fwidx/2,y0/2-fwidy/2+1:y0/2+fwidy/2,z0/2-fwidz/2+1:z0/2+fwidz/2);
rat = 2*round(x0/max([fwidx fwidy fwidz]));
x = rat*fwidx;
y = rat*fwidy;
z = rat*fwidz;
kdat2 = zeros([x,y,z]);
kdat2(x/2-fwidx/2+1:x/2+fwidx/2,y/2-fwidy/2+1:y/2+fwidy/2,z/2-fwidz/2+1:z/2+fwidz/2) = kdat.*F;
tIm = fftshift(ifftn(ifftshift(kdat2)));

%---------------------------------------------
% Shrink FoV
%---------------------------------------------
tIm2 = tIm(20:x-19,20:y-19,20:z-19);
[x,y,z] = size(tIm2);

%---------------------------------------------
% Convert Back
%---------------------------------------------
kdat3 = fftshift(fftn(ifftshift(tIm2)));
kdat4 = kdat3(x/2-x0/2+1:x/2+x0/2,y/2-y0/2+1:y/2+y0/2,z/2-z0/2+1:z/2+z0/2);
Prof = fftshift(ifftn(ifftshift(kdat4)));
Prof = Prof/max(Prof(:));
Prof(Prof<0.35) = 0.35;

%---------------------------------------------
% Display
%---------------------------------------------
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = z0; 
IMSTRCT.rows = floor(sqrt(z0)+1); IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 0001; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(Prof,IMSTRCT);

%---------------------------------------------
% Correct
%---------------------------------------------
Im = Im0./Prof;
Im = Im/max(Im(:));

%---------------------------------------------
% Display
%---------------------------------------------
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = z0; 
IMSTRCT.rows = floor(sqrt(z0)+1); IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1002; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(Im,IMSTRCT);

%---------------------------------------------
% Display
%---------------------------------------------
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = z0; 
IMSTRCT.rows = floor(sqrt(z0)+1); IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 0003; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(Im,IMSTRCT);

%---------------------------------------------
% Return
%--------------------------------------------- 


Status2('done','',2);
Status2('done','',3);

