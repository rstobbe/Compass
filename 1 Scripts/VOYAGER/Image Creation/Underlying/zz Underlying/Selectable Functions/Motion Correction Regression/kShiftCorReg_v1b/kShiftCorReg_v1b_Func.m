%=========================================================
% 
%=========================================================

function [KSHFTCORREG,err] = kShiftCorReg_v1b_Func(KSHFTCORREG,INPUT)

Status2('busy','Correct for Shifts in kSpace from Motion',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
GrdDatCen = INPUT.GrdDatCen;
cenrad = INPUT.cenrad;
subsamp = INPUT.subsamp;
clear INPUT;

%---------------------------------------------
% Get Variables
%---------------------------------------------      
kstep = IMP.impPROJdgn.kstep;

%---------------------------------------------
% Interpolate
%---------------------------------------------
Status2('busy','Interpolate k-Space',3);
[X,Y,Z] = meshgrid((-cenrad:cenrad),(-cenrad:cenrad),(-cenrad:cenrad));
ceninterparr = (-cenrad:0.1:cenrad);
[XI,YI,ZI] = meshgrid(ceninterparr,ceninterparr,ceninterparr);
iagrd = interp3(X,Y,Z,abs(GrdDatCen),XI,YI,ZI,'cubic');  

%---------------------------------------------
% Find Centre 
%---------------------------------------------  
maxgrd = max(iagrd(:));
[xind,yind,zind] = ind2sub(size(iagrd),find(iagrd == maxgrd,1));
kshfts(1) = kstep*ceninterparr(xind)/subsamp;
kshfts(2) = kstep*ceninterparr(yind)/subsamp;
kshfts(3) = kstep*ceninterparr(zind)/subsamp;   

%---------------------------------------------
% Plot
%---------------------------------------------  
figure(101); hold on;
iagrd = iagrd/maxgrd;
plot(kstep*ceninterparr/subsamp,iagrd(:,yind,zind),'b','linewidth',2);
plot(kstep*ceninterparr/subsamp,iagrd(xind,:,zind),'r','linewidth',2);
plot(kstep*ceninterparr/subsamp,squeeze(iagrd(xind,yind,:)),'g','linewidth',2);
xlabel('k-space (1/m)'); ylabel('relative value');

%--------------------------------------------
% Return
%--------------------------------------------
KSHFTCORREG.kshfts = kshfts;

Status2('done','',2);
Status2('done','',3);


