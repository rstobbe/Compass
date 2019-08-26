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
%IMP = INPUT.IMP;
%PROJimp = IMP.PROJimp;
%PROJdgn = IMP.impPROJdgn;
grd1 = INPUT.grd1.GrdDat;
grd2 = INPUT.grd2.GrdDat;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
Ksz = INPUT.grd1.Ksz;
C = (Ksz+1)/2;

%---------------------------------------------
% Compare Phases
%---------------------------------------------
phgrd1 = angle(grd1);
phgrd2 = angle(grd2);
phdif = phgrd2 - phgrd1;
figure; hold on;
p = 1;
t = [-1 0 1];
for n = -1:1
    for m = -1:1
        tphdif = squeeze(phdif(C+n,:,C+m));
        Atphdif(p,:) = tphdif(C-1:C+1);
        plot(t,Atphdif(p,:));
        p = p+1;
    end
end
mAtphdif = mean(Atphdif,1);
plot(t,mAtphdif,'r');
[r,m,b] = regression(t,mAtphdif);
plot(t,t*m+b,'g');

slope = m
offset = b

%---------------------------------------------
% Return
%---------------------------------------------

Status2('done','',2);
Status2('done','',3);