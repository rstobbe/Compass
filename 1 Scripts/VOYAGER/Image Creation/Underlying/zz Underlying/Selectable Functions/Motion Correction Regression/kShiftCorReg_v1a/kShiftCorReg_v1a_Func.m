%=========================================================
% 
%=========================================================

function [KSHFTCOR,err] = kShiftCorMSYB_v1a_Func(KSHFTCOR,INPUT)

Status2('busy','Correct for Shifts in kSpace from Motion',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
KSMP = INPUT.KSMP;
kshfts0 = KSMP.KSHFT.kshfts;
MOTCOR = INPUT.MOTCOR;
GrdDatCen = INPUT.GrdDatCen;
IMP = INPUT.IMP;
Kmat = IMP.Kmat;
clear INPUT;

%---------------------------------------------
% Get Variables
%---------------------------------------------
cenrad = MOTCOR.cenrad;       
kstep = IMP.impPROJdgn.kstep;
nproj = IMP.PROJimp.nproj;
npro = IMP.PROJimp.npro;
subsamp = MOTCOR.GRD.SS;

%---------------------------------------------
% Determine kSpace Shift of Each Trajectory
%---------------------------------------------
Status2('busy','Correct for Shifts in kSpace from Motion',2);
for n = 1:nproj
    %-----------------------------------------
    % Interpolate
    [X,Y,Z] = meshgrid((-cenrad:cenrad),(-cenrad:cenrad),(-cenrad:cenrad));
    ceninterparr = (-cenrad:0.1:cenrad);
    [XI,YI,ZI] = meshgrid(ceninterparr,ceninterparr,ceninterparr);
    iagrd = interp3(X,Y,Z,squeeze(abs(GrdDatCen(n,:,:,:))),XI,YI,ZI,'cubic');  

    %---------------------------------------------
    % Find Centre    
    maxgrd = max(iagrd(:));
    [xind(n),yind(n),zind(n)] = ind2sub(size(iagrd),find(iagrd == maxgrd,1));
    figure(101); hold on;
    iagrd = iagrd/maxgrd;
    plot(kstep*ceninterparr/subsamp,iagrd(:,yind(n),zind(n)),'b','linewidth',2);
    plot(kstep*ceninterparr/subsamp,iagrd(xind(n),:,zind(n)),'r','linewidth',2);
    plot(kstep*ceninterparr/subsamp,squeeze(iagrd(xind(n),yind(n),:)),'g','linewidth',2);
    xlabel('k-space (1/m)'); ylabel('relative value');
    kshfts(n,1) = kstep*ceninterparr(xind(n))/subsamp;
    kshfts(n,2) = kstep*ceninterparr(yind(n))/subsamp;
    kshfts(n,3) = kstep*ceninterparr(zind(n))/subsamp;   

    %---------------------------------------------
    % Test
    figure(102); hold on;
    plot(kshfts(:,1),'b*'); plot(-kshfts0(:,1),'bo');
    plot(kshfts(:,2),'r*'); plot(-kshfts0(:,2),'ro');
    plot(kshfts(:,3),'g*'); plot(-kshfts0(:,3),'go');
    xlabel('trajectory number'); ylabel('k-Space Shift (1/m)');    
end

magkshfts = sqrt(kshfts(:,1).^2 + kshfts(:,2).^2 + kshfts(:,3).^2);
stdmagkshfts = std(magkshfts);

%---------------------------------------------
% Shift Trajectories
%---------------------------------------------
for n = 1:nproj
    for m = 1:3
        Kmat(n,:,m) = Kmat(n,:,m) - kshfts(n,m)*ones(1,npro);
    end
end

%--------------------------------------------
% Return
%--------------------------------------------
KSHFTCOR.Kmat = Kmat;
KSHFTCOR.kshfts = kshfts;
KSHFTCOR.kshfts0 = kshfts0;
KSHFTCOR.magkshfts = magkshfts;
KSHFTCOR.stdmagkshfts = stdmagkshfts;

Status2('done','',2);
Status2('done','',3);


