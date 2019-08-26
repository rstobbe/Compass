%=========================================================
% 
%=========================================================

function [COMP,err] = Compare2Samplings_v1a_Func(INPUT)

Status('busy','Compare Two Samplings');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
COMP = INPUT.COMP;
IMP = INPUT.IMP;
Kmat = IMP.Kmat;
PROJimp = IMP.PROJimp;
PROJdgn = IMP.impPROJdgn;
samp1 = INPUT.samp1.SampDat;
samp2 = INPUT.samp2.SampDat;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
nproj = PROJdgn.nproj;
npro = PROJimp.npro;
kstep = PROJdgn.kstep;

%---------------------------------------------
% SampDat in Matrix
%---------------------------------------------
samp1 = DatArr2Mat(samp1,nproj,npro);
samp2 = DatArr2Mat(samp2,nproj,npro);

%---------------------------------------------
% Compare Phases
%---------------------------------------------
curproj = 18;
nKmat = squeeze(Kmat(curproj,:,:))/kstep;
phsamp1 = angle(samp1(curproj,:));
phsamp2 = angle(samp2(curproj,:));
figure; hold on;
phdif = phsamp2 - phsamp1;
phdif(phdif < 0) = phdif(phdif < 0) + 2*pi;
plot(nKmat(:,2),phdif,'r*');




%---------------------------------------------
% Return
%---------------------------------------------
COMP.Im = Im;
COMP.ImSz = IC.ImSz;
COMP.zf = IC.zf;
COMP.returnfov = IC.returnfov;
COMP.IC = IC;

Status('done','');
Status2('done','',2);
Status2('done','',3);