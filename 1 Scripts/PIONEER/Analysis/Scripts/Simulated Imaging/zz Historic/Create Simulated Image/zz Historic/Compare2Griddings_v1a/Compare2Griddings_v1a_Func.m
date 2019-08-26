%=========================================================
% 
%=========================================================

function [COMP,err] = Compare2Griddings_v1a_Func(INPUT)

Status('busy','Compare Two Griddings');
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
grd1 = INPUT.grd1.GrdDat;
grd2 = INPUT.grd2.GrdDat;
Ksz = INPUT.grd1.Ksz;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
nproj = PROJdgn.nproj;
npro = PROJimp.npro;
kstep = PROJdgn.kstep;
C = (Ksz+1)/2;

%---------------------------------------------
% Compare Phases
%---------------------------------------------
phgrd1 = angle(grd1);
phgrd2 = angle(grd2);
phdif = phgrd2 - phgrd1;
figure; hold on;
for n = -1:1
    for m = -1:1
        tphdif = squeeze(phdif(C+n,:,C+m));
        plot(tphdif);
    end
end



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