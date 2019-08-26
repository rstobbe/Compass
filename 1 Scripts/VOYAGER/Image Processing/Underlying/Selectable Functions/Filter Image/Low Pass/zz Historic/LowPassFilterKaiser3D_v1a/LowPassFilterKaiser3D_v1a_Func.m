%===========================================
% 
%===========================================

function [FILT,err] = LowPassFilterKaiser3D_v1a_Func(FILT,INPUT)

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

dimx = 2*(round((x*lpkmax/(1000*x/(2*ReconPars.ImfovTB)))/2)); 
dimy = 2*(round((y*lpkmax/(1000*y/(2*ReconPars.ImfovLR)))/2)); 
dimz = 2*(round((z*lpkmax/(1000*z/(2*ReconPars.ImfovIO)))/2)); 

%---------------------------------------------
% Drop Resolution
%---------------------------------------------
Filt = Kaiser_v1b(dimx,dimy,dimz,FILT.beta,'unsym');
botx = (x-dimx)/2+1;
topx = botx+dimx-1;
boty = (y-dimy)/2+1;
topy = boty+dimy-1;
botz = (z-dimz)/2+1;
topz = botz+dimz-1;
for n = 1:nims
    k = fftshift(ifftn(ifftshift(Im(:,:,:,n))));
    k2 = zeros(size(k));
    k2(botx:topx,boty:topy,botz:topz) = Filt.*k(botx:topx,boty:topy,botz:topz);
    Im2(:,:,:,n) = fftshift(fftn(ifftshift(k2)));
end

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
FILT.Im = Im2;

Status2('done','',2);
Status2('done','',3);

