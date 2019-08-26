%===========================================
% 
%===========================================

function [ISHIM,err] = ShimImageIntensityLPF_v1a_Func(ISHIM,INPUT)

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
[x,y,z] = size(Im0);
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = z; 
IMSTRCT.rows = floor(sqrt(z)+1); IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(Im0,IMSTRCT);

%-------------------------------------------
% Create Filter
%-------------------------------------------
Status2('busy','Create Filter',3);
fwidx = 2*round((ReconPars.fovx/ISHIM.profres)/2);
fwidy = 2*round((ReconPars.fovy/ISHIM.profres)/2);
fwidz = 2*round((ReconPars.fovz/ISHIM.profres)/2);
F0 = Kaiser_v1b(fwidx,fwidy,fwidz,ISHIM.proffilt,'unsym');
F = zeros(x,y,z);
F(x/2-fwidx/2+1:x/2+fwidx/2,y/2-fwidy/2+1:y/2+fwidy/2,z/2-fwidz/2+1:z/2+fwidz/2) = F0;

%---------------------------------------------
% Profile
%---------------------------------------------
kdat = fftshift(fftn(ifftshift(Im0)));
Prof = fftshift(ifftn(ifftshift(kdat.*F)));
Prof = Prof/max(Prof(:));
Prof(Prof<0.15) = 0.15;

%---------------------------------------------
% Display
%---------------------------------------------
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = z; 
IMSTRCT.rows = floor(sqrt(z)+1); IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1001; 
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
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = z; 
IMSTRCT.rows = floor(sqrt(z)+1); IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1002; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(Im,IMSTRCT);

%---------------------------------------------
% Display
%---------------------------------------------
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = z; 
IMSTRCT.rows = floor(sqrt(z)+1); IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1003; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(Im,IMSTRCT);

%---------------------------------------------
% Return
%--------------------------------------------- 


Status2('done','',2);
Status2('done','',3);

