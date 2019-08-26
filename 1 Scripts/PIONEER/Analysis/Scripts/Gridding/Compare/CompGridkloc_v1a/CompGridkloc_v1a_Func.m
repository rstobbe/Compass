%=========================================================
% 
%=========================================================

function [COMP,err] = CompGridkloc_v1a_Func(INPUT)

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
%PROJimp = IMP.PROJimp;
PROJdgn = IMP.impPROJdgn;
grd1 = INPUT.grd1.GrdDat;
grd2 = INPUT.grd2.GrdDat;
Ksz = INPUT.grd1.Ksz;
SS = INPUT.grd1.SS;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
C = (Ksz+1)/2;
kstep = PROJdgn.kstep;

%---------------------------------------------
% Plot
%---------------------------------------------
%PlotkSpace(grd1,100);
%PlotkSpace(grd2,101);

%---------------------------------------------
% Isolate Middle
%---------------------------------------------
Sub = 10;
agrd1 = abs(grd1(C-Sub:C+Sub,C-Sub:C+Sub,C-Sub:C+Sub));
agrd2 = abs(grd2(C-Sub:C+Sub,C-Sub:C+Sub,C-Sub:C+Sub));

%---------------------------------------------
% Interpolate1
%---------------------------------------------
[X,Y,Z] = meshgrid((-10:10),(-10:10),(-10:10));
[XI,YI,ZI] = meshgrid((-10:0.1:10),(-10:0.1:10),(-10:0.1:10));
iagrd1 = interp3(X,Y,Z,agrd1,XI,YI,ZI,'cubic');
iagrd2 = interp3(X,Y,Z,agrd2,XI,YI,ZI,'cubic');

max1 = max(iagrd1(:));
max2 = max(iagrd2(:));
[x1,y1,z1] = ind2sub(size(iagrd1),find(iagrd1 == max1,1));
[x2,y2,z2] = ind2sub(size(iagrd2),find(iagrd2 == max2,1));
figure(100); hold on;
iagrd1 = iagrd1/max1;
iagrd2 = iagrd2/max2;
plot(kstep*(-10:0.1:10)/SS,iagrd1(:,y1,z1),'b','linewidth',2);
plot(kstep*(-10:0.1:10)/SS,iagrd1(x1,:,z1),'r','linewidth',2);
plot(kstep*(-10:0.1:10)/SS,squeeze(iagrd1(x1,y1,:)),'g','linewidth',2);
plot(kstep*(-10:0.1:10)/SS,iagrd2(:,y2,z2),'b:','linewidth',2);
plot(kstep*(-10:0.1:10)/SS,iagrd2(x2,:,z2),'r:','linewidth',2);
plot(kstep*(-10:0.1:10)/SS,squeeze(iagrd2(x2,y2,:)),'g:','linewidth',2);

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);


%====================================================
% Plot kSpace
%====================================================
function PlotkSpace(kSpace,fighnd) 

sz = size(kSpace);
rows = floor(sqrt(sz(3))); 
IMSTRCT.type = 'abs';
minval = 0;
maxval = max(abs(kSpace(:)));
%IMSTRCT.type = 'phase';
%minval = -pi/5;
%maxval = pi/5;
IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = rows; IMSTRCT.lvl = [minval maxval]; IMSTRCT.SLab = 0; IMSTRCT.figno = fighnd; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; 
IMSTRCT.figsize = [1000 1000];
AxialMontage_v2a(kSpace,IMSTRCT);  

