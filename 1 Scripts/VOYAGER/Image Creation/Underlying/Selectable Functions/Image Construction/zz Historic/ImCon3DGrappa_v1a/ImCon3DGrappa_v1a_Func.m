%=====================================================
%
%=====================================================

function [GRAPPA,err] = ImCon3DGrappa_v1a_Func(GRAPPA,INPUT)

Status2('busy','Grappa Reconstruction',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Dat = INPUT.Dat;
GKERN = GRAPPA.GKERN;
GCDAT = GRAPPA.GCDAT;
GWCALC = GRAPPA.GWCALC;
GCONV = GRAPPA.GCONV;
clear INPUT;

%Dat0 = Dat;
%for n = 1:8
%    Dat(:,:,:,n) = Dat0(:,:,:,1);
%end
%Dat = Dat(:,:,:,1:2);
%Dat(:,:,:,2) = Dat(:,:,:,1);
%Dat = Dat(:,:,:,1);

%---------------------------------------------
% Image Test
%---------------------------------------------
Im = fftshift(ifftn(ifftshift(Dat(:,:,:,1)))); 
sz = size(Im);
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = floor(sqrt(sz(3))); IMSTRCT.lvl = [0 max(abs(Im(:)))]; IMSTRCT.SLab = 0; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
IMSTRCT.figno = 2000;
AxialMontage_v2a(Im,IMSTRCT);

IMSTRCT.figno = 1000;
IMSTRCT.lvl = [0 max(max(max(log(abs(Dat(:,:,:,1))))))];
AxialMontage_v2a(squeeze(log(abs(Dat(:,:,:,1)))),IMSTRCT);


%---------------------------------------------
% Get Grappa Kernel
%---------------------------------------------
func = str2func([GRAPPA.kernfunc,'_Func']);  
INPUT = '';
[GKERN,err] = func(GKERN,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Get Grappa Calibration Data
%---------------------------------------------
func = str2func([GRAPPA.caldatfunc,'_Func']);  
INPUT.kDat = Dat;
[GCDAT,err] = func(GCDAT,INPUT);
if err.flag
    return
end
clear INPUT;
cDat = GCDAT.cDat;

%---------------------------------------------
% Calculate Grappa Weights
%---------------------------------------------
func = str2func([GRAPPA.wcalcfunc,'_Func']);  
INPUT.GKERN = GKERN;
INPUT.cDat = cDat;
[GWCALC,err] = func(GWCALC,INPUT);
if err.flag
    return
end
clear INPUT;
G = GWCALC.G;
%test = max(abs(G(:)))

%---------------------------------------------
% Grappa Reconstruct
%---------------------------------------------
func = str2func([GRAPPA.reconfunc,'_Func']);  
INPUT.GKERN = GKERN;
INPUT.G = G;
INPUT.kDat = Dat;
[GCONV,err] = func(GCONV,INPUT);
if err.flag
    return
end
clear INPUT;
kMat1 = GCONV.kDat;

figure(3000); hold on;
plot(real(Dat(:,33,33,1)),'r');
plot(real(kMat1(:,33,33,1)),'k');
figure(3001); hold on;
plot(imag(Dat(:,33,33,1)),'r');
plot(imag(kMat1(:,33,33,1)),'k');

%---------------------------------------------
% Image Test
%---------------------------------------------
IMSTRCT.figno = 1001;
IMSTRCT.lvl = [0 max(max(max(log(abs(kMat1(:,:,:,1))))))];
AxialMontage_v2a(squeeze(log(abs(kMat1(:,:,:,1)))),IMSTRCT);

Im = fftshift(ifftn(ifftshift(kMat1(:,:,:,1)))); 
IMSTRCT.figno = 2001;
IMSTRCT.lvl = [0 max(abs(Im(:)))];
AxialMontage_v2a(Im,IMSTRCT);

%---------------------------------------------
% Return
%---------------------------------------------
GRAPPA.kDat = kDat;

Status2('done','',2);
Status2('done','',3);

