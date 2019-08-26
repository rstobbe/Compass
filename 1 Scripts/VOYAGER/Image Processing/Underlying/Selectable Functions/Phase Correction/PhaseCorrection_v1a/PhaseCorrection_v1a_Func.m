%===========================================
% 
%===========================================

function [PCOR,err] = PhaseCorrection_v1a_Func(PCOR,INPUT)

Status2('busy','Phase Correction',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
Im0 = INPUT.Im;
ReconPars = INPUT.ReconPars;
%visuals = INPUT.visuals;
visuals = 'Yes';
clear INPUT;

%---------------------------------------------
% Display
%---------------------------------------------
[x0,y0,z0] = size(Im0);
if strcmp(visuals,'Yes')
    IMSTRCT.type = 'phase'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = z0; 
    IMSTRCT.rows = floor(sqrt(z0)+1); IMSTRCT.lvl = [-pi pi]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
    AxialMontage_v2a(Im0,IMSTRCT);
end

%-------------------------------------------
% Create Filter
%-------------------------------------------
Status2('busy','Create Filter',3);
fwidx = 2*round((ReconPars.ImfovLR/PCOR.profres)/2);
fwidy = 2*round((ReconPars.ImfovTB/PCOR.profres)/2);
fwidz = 2*round((ReconPars.ImfovIO/PCOR.profres)/2);
F = Kaiser_v1b(fwidx,fwidy,fwidz,PCOR.proffilt,'unsym');
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
% Convert Back
%---------------------------------------------
kdat3 = fftshift(fftn(ifftshift(tIm)));
kdat4 = kdat3(x/2-x0/2+1:x/2+x0/2,y/2-y0/2+1:y/2+y0/2,z/2-z0/2+1:z/2+z0/2);
Prof = fftshift(ifftn(ifftshift(kdat4)));

%---------------------------------------------
% Display
%---------------------------------------------
if strcmp(visuals,'Yes')
    IMSTRCT.type = 'phase'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = z0; 
    IMSTRCT.rows = floor(sqrt(z0)+1); IMSTRCT.lvl = [-pi pi]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1001; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
    AxialMontage_v2a(Prof,IMSTRCT);
end

%---------------------------------------------
% Correct
%---------------------------------------------
Im = Im0.*exp(-1i*(angle(Prof)));

%---------------------------------------------
% Display
%---------------------------------------------
if strcmp(visuals,'Yes')
    IMSTRCT.type = 'phase'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = z0; 
    IMSTRCT.rows = floor(sqrt(z0)+1); IMSTRCT.lvl = [-pi pi]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1002; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
    AxialMontage_v2a(Im,IMSTRCT);
end

%---------------------------------------------
% Return
%--------------------------------------------- 
PCOR.Im = Im;

Status2('done','',2);
Status2('done','',3);

