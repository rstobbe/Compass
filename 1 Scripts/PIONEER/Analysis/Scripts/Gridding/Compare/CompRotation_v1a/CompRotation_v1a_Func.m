%=========================================================
% 
%=========================================================

function [COMP,err] = CompRotation_v1a_Func(INPUT)

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
SS1 = INPUT.grd1.SS;
SS2 = INPUT.grd2.SS;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
if SS1 ~= SS2
    error
end
SS = SS1;
C = (Ksz+1)/2;
kstep = PROJdgn.kstep;
trajmax = 4.0;   
cenrad = ceil(trajmax*SS);

%---------------------------------------------
% Image Test
%---------------------------------------------
Im = fftshift(ifftn(grd1));
maxim = max(abs(Im(:)));
Im = abs(Im)/maxim;
Im = flipdim(Im,1);
Im = flipdim(Im,2);
Im = flipdim(Im,3);
PlotkSpace(Im,'abs',0,maxim,50) 
%imshow(squeeze(Im(:,:,C)),[0 1]);

%---------------------------------------------
% Image Test
%---------------------------------------------
Im = fftshift(ifftn(grd2));
maxim = max(abs(Im(:)));
Im = abs(Im)/maxim;
Im = flipdim(Im,1);
Im = flipdim(Im,2);
Im = flipdim(Im,3);
PlotkSpace(Im,'abs',0,maxim,51) 
%imshow(squeeze(Im(:,:,C)),[0 1]);

%---------------------------------------------
% Isolate Middle
%---------------------------------------------
grd1 = grd1(C-cenrad:C+cenrad,C-cenrad:C+cenrad,C-cenrad:C+cenrad);
grd2 = grd2(C-cenrad:C+cenrad,C-cenrad:C+cenrad,C-cenrad:C+cenrad);

%rgrd2 = Rotate3DMatrix_v1b(grd2,0,0,-20);

%---------------------------------------------
% Plot
%---------------------------------------------
plotks = 0;
if plotks == 1
    minr = min(min(real([grd1(:) grd2(:)])));
    maxr = max(max(real([grd1(:) grd2(:)])));
    mini = min(min(imag([grd1(:) grd2(:)])));
    maxi = max(max(imag([grd1(:) grd2(:)])));
    PlotkSpace(grd1,'real',minr,maxr,100);
    PlotkSpace(grd2,'real',minr,maxr,101);
    PlotkSpace(grd1,'imag',mini,maxi,200);
    PlotkSpace(grd2,'imag',mini,maxi,201);
end

%---------------------------------------------
% Find Rotation
%---------------------------------------------
SrchMax = 4;
rotx = (-SrchMax:2:SrchMax);
%rotx = 0;
roty = (-SrchMax:2:SrchMax);
%roty = 0;
rotz = (-SrchMax:2:SrchMax);
%rotz = 0;

Status2('busy','Correct for Rotation',2);
for n = 1:length(rotx)
    for m = 1:length(roty)
        for p = 1:length(rotz)
            rgrd2 = Rotate3DMatrix_v1b(grd2,rotx(n),roty(m),rotz(p));
            Ierr(n,m,p) = sum((imag(rgrd2(:)) - imag(grd1(:))));
            Isqerr(n,m,p) = sum((imag(rgrd2(:)) - imag(grd1(:))).^2);
            Icubeerr(n,m,p) = sum((abs(imag(rgrd2(:)) - imag(grd1(:)))).^3);
            Aerr(n,m,p) = sum((angle(rgrd2(:)) - angle(grd1(:))));
            Asqerr(n,m,p) = sum((angle(rgrd2(:)) - angle(grd1(:))).^2);
            Rsqerr(n,m,p) = sum((real(rgrd2(:)) - real(grd1(:))).^2);
            L1err(n,m,p) = sum((abs(rgrd2(:) - grd1(:))));
            L2err(n,m,p) = sqrt(sum((abs(rgrd2(:) - grd1(:))).^2));
            Status2('busy',[num2str(rotx(n)),' ',num2str(roty(m)),' ',num2str(rotz(p))],3);
        end
    end
end
%figure(300); hold on;
%plot(rotz,squeeze(sqerrI(1,1,:)),'r')
RotErr = Isqerr;

[xind,yind,zind] = ind2sub(size(RotErr),find(RotErr == min(RotErr(:)),1));
figure(301); hold on;
plot(rotx,squeeze(RotErr(:,yind,zind)),'b:');
plot(roty,squeeze(RotErr(xind,:,zind)),'r:');
plot(rotz,squeeze(RotErr(xind,yind,:)),'g:');

%-------------------------------------------
% Interpolate
%-------------------------------------------
[X,Y,Z] = meshgrid(rotx,roty,rotz);
ceninterparr = (-SrchMax:0.1:SrchMax);
[XI,YI,ZI] = meshgrid(ceninterparr,ceninterparr,ceninterparr);
ierr = interp3(X,Y,Z,RotErr,XI,YI,ZI,'cubic');  

[xind,yind,zind] = ind2sub(size(ierr),find(ierr == min(ierr(:)),1));
figure(301); hold on;
plot(ceninterparr,squeeze(ierr(:,yind,zind)),'b');
plot(ceninterparr,squeeze(ierr(xind,:,zind)),'r');
plot(ceninterparr,squeeze(ierr(xind,yind,:)),'g');

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);


%====================================================
% Plot kSpace
%====================================================
function PlotkSpace(kSpace,type,min,max,fighnd) 

sz = size(kSpace);
rows = floor(sqrt(sz(3))); 
IMSTRCT.type = type; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = rows; IMSTRCT.lvl = [min max]; IMSTRCT.SLab = 0; IMSTRCT.figno = fighnd; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; 
IMSTRCT.figsize = [1000 1000];
AxialMontage_v2a(kSpace,IMSTRCT);  

