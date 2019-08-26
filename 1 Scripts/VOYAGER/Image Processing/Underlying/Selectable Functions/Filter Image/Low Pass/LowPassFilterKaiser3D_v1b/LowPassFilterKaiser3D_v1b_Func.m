%===========================================
% 
%===========================================

function [FILT,err] = LowPassFilterKaiser3D_v1b_Func(FILT,INPUT)

Status2('busy','Create Filter',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG;
ReconPars = IMG.ReconPars;
Im = IMG.Im;
clear INPUT;

%---------------------------------------------
% Calculate Matrix Dimensions
%--------------------------------------------- 
if ndims(Im) == 4
    [x,y,z,nims] = size(Im);
else
    [x,y,z] = size(Im);
    nims = 1;
end
%imkmaxx = 1000/(2*ReconPars.voxx);
%imkmaxy = 1000/(2*ReconPars.voxy);
%imkmaxz = 1000/(2*ReconPars.voxx);
imkmaxx = 1000/(2*ReconPars.ImvoxTB);
imkmaxy = 1000/(2*ReconPars.ImvoxLR);
imkmaxz = 1000/(2*ReconPars.ImvoxIO);
lpkmax = FILT.kmax;
if lpkmax > imkmaxx
    err.flag = 1;
    err.msg = 'Filter kmax > Image kmax in x-dimension';
    return
end
if lpkmax > imkmaxy
    err.flag = 1;
    err.msg = 'Filter kmax > Image kmax in y-dimension';
    return
end
if lpkmax > imkmaxz
    err.flag = 1;
    err.msg = 'Filter kmax > Image kmax in z-dimension';
    return
end

%---------------------------------------------
% Bump FoV
%---------------------------------------------
rFoVinc = 2;
x2 = 2*round(x*rFoVinc/2);
y2 = 2*round(y*rFoVinc/2);
z2 = 2*round(z*rFoVinc/2);
Im2 = zeros(x2,y2,z2,nims);

botx2 = (x2-x)/2+1;
topx2 = botx2+x-1;
boty2 = (y2-y)/2+1;
topy2 = boty2+y-1;
botz2 = (z2-z)/2+1;
topz2 = botz2+z-1;

Im2(botx2:topx2,boty2:topy2,botz2:topz2) = Im;
Im = Im2;

%---------------------------------------------
% Drop Resolution
%---------------------------------------------
dimx = 2*round(lpkmax*ReconPars.ImfovTB*rFoVinc/1000);
dimy = 2*round(lpkmax*ReconPars.ImfovLR*rFoVinc/1000);
dimz = 2*round(lpkmax*ReconPars.ImfovIO*rFoVinc/1000);

Filt = Kaiser_v1b(dimx,dimy,dimz,FILT.beta,'unsym');
botx = (x2-dimx)/2+1;
topx = botx+dimx-1;
boty = (y2-dimy)/2+1;
topy = boty+dimy-1;
botz = (z2-dimz)/2+1;
topz = botz+dimz-1;
for n = 1:nims
    k = fftshift(ifftn(ifftshift(Im(:,:,:,n))));
    k2 = zeros(size(k));
    k2(botx:topx,boty:topy,botz:topz) = Filt.*k(botx:topx,boty:topy,botz:topz);
    Im2(:,:,:,n) = fftshift(fftn(ifftshift(k2)));
end

%---------------------------------------------
% Return FoV
%---------------------------------------------
Im = Im2(botx2:topx2,boty2:topy2,botz2:topz2);

%---------------------------------------------
% Update ReconPars
%--------------------------------------------- 
ReconPars.LPkmax = FILT.kmax;
ReconPars.LPFilter = ['Kaiser',num2str(FILT.beta)];
FILT.ReconPars = ReconPars;

%---------------------------------------------
% Panel Output
%---------------------------------------------
Panel(1,:) = {'FilterMethod',FILT.method,'Output'};
Panel(2,:) = {'kmax (1/m)',FILT.kmax,'Output'};
Panel(3,:) = {'beta',FILT.beta,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FILT.PanelOutput = PanelOutput;

%---------------------------------------------
% Return
%--------------------------------------------- 
FILT.Im = Im;

Status2('done','',2);
Status2('done','',3);

