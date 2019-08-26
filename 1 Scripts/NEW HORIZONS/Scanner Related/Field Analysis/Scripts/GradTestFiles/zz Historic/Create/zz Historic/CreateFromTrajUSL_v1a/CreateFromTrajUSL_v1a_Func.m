%=====================================================
% 
%=====================================================

function [GRD,err] = CreateFromTrajUSL_v1a_Func(GRD,INPUT)

Status('busy','Create Test Trajectory');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SYSWRT = INPUT.SYSWRT;
TSAMP = INPUT.TSAMP;
IMP = INPUT.IMP;
clear INPUT

%---------------------------------------------
% Define Trajectory
%---------------------------------------------
if strcmp(GRD.usetrajdir,'x') || strcmp(GRD.usetrajdir,'X')
    G0scnr = IMP.G(GRD.usetrajnum,:,1);
    G0recon = IMP.Grecon(GRD.usetrajnum,:,1);
    Kmat = IMP.Kmat(GRD.usetrajnum,:,1);
elseif strcmp(GRD.usetrajdir,'y') || strcmp(GRD.usetrajdir,'Y')
    G0scnr = IMP.G(GRD.usetrajnum,:,2);
    G0recon = IMP.Grecon(GRD.usetrajnum,:,2);
    Kmat = IMP.Kmat(GRD.usetrajnum,:,2);
else
    error(); % finish
end

%---------------------------------------------
% PrePad - Add Zeros
%---------------------------------------------
gseg = IMP.GQNT.gseg;
padN = round(GRD.pregdur0/gseg);
GRD.pregdur = padN*gseg;
ZeroPad = zeros(1,padN);

zpGscnr = [ZeroPad G0scnr];
zpGrecon = [ZeroPad G0recon];

GRD.Gscnr(:,:,1) = zpGscnr;
GRD.Gscnr(:,:,2) = zpGscnr;
GRD.Gscnr(:,:,3) = zpGscnr;
GRD.Grecon(:,:,1) = zpGrecon;
GRD.Grecon(:,:,2) = zpGrecon;
GRD.Grecon(:,:,3) = zpGrecon;
GRD.Kmat(:,:,1) = Kmat;
GRD.Kmat(:,:,2) = Kmat;
GRD.Kmat(:,:,3) = Kmat;

GRD.gseg = gseg;
GRD.tgwfm = IMP.GWFM.tgwfm + GRD.pregdur;
GRD.qTscnr = (0:GRD.gseg:GRD.tgwfm);
GRD.qTrecon = (0:GRD.gseg:length(GRD.Grecon)*GRD.gseg);

GRD.samp0 = IMP.samp;
GRD.samp = GRD.samp0 + GRD.pregdur;

%---------------------------------------------
% Test Sampling
%---------------------------------------------
func = str2func([GRD.testsampfunc,'_Func']);
INPUT.IMP = IMP;
[TSAMP,err] = func(TSAMP,INPUT);
if err.flag
    return
end
mIMP = TSAMP.IMP;
clear INPUT

%---------------------------------------------
% Update modified IMP structure
%---------------------------------------------
mIMP.GWFM.tgwfm = GRD.tgwfm;
mIMP.impPROJdgn.vox = 0;
mIMP.impPROJdgn.fov = 0;
mIMP.impPROJdgn.nproj = 1;

%---------------------------------------------
% Write System
%---------------------------------------------
func = str2func([GRD.syswrtfunc,'_Func']);
INPUT.G = GRD.Gscnr;
INPUT.IMP = mIMP;
[SYSWRT,err] = func(SYSWRT,INPUT);
if err.flag
    return
end
clear INPUT


