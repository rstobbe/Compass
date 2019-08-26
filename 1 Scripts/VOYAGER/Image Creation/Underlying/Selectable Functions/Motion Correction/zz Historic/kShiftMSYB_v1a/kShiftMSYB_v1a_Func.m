%=========================================================
% 
%=========================================================

function [MOTCOR,err] = kShiftMSYB_v1a_Func(MOTCOR,INPUT)

Status2('busy','Correct for Shifts in kSpace from Motion',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DAT = INPUT.DAT;
KSMP = INPUT.KSMP;
kshfts0 = KSMP.KSHFT.kshfts;
IMP = INPUT.IMP;
GRD = MOTCOR.GRD;
Kmat = IMP.Kmat;
clear INPUT;

%---------------------------------------------
% Get Variables
%---------------------------------------------
trajmax = MOTCOR.trajmax;       
kstep = IMP.impPROJdgn.kstep;
nproj = IMP.PROJimp.nproj;
npro = IMP.PROJimp.npro;
subsamp = GRD.SS;
cenrad = ceil(trajmax*subsamp);

%---------------------------------------------
% Isolate Centre
%---------------------------------------------
rad = (sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2))/kstep;
rad = mean(rad,1);
subnpro = find(rad < (trajmax),1,'last');
subkmax = rad(subnpro)*kstep;
subKmat = Kmat(:,1:subnpro,:);
subDAT = DAT(:,1:subnpro,:);

%---------------------------------------------
% Gridding Setup
%---------------------------------------------
IMP.PROJimp.nproj = 1;
IMP.PROJimp.npro = subnpro;
IMP.impPROJdgn.kmax = subkmax;
GRD.type = 'complex';
INPUT.GRD = GRD;
gridfunc = str2func([MOTCOR.gridfunc,'_Func']);
GrdDatCen = zeros(nproj,2*cenrad+1,2*cenrad+1,2*cenrad+1);

%---------------------------------------------
% Grid Central Portion of Each Trajectory
%---------------------------------------------
%nproj = 1;
for n = 1:nproj
    %-----------------------------------------
    % Isolate Each Trajectory
    DAT1 = subDAT(n,:);
    Kmat1 = subKmat(n,:,:);
    IMP.Kmat = Kmat1;    

    %-----------------------------------------
    % Grid Each Trajectory
    INPUT.IMP = IMP;
    INPUT.DAT = DAT1;
    [GRD,err] = gridfunc(GRD,INPUT);
    if err.flag
        return
    end
    %-----------------------------------------
    % Isolate Centre   
    Ksz = GRD.Ksz;
    C = (Ksz+1)/2;
    GrdDatCen(n,:,:,:) = GRD.GrdDat(C-cenrad:C+cenrad,C-cenrad:C+cenrad,C-cenrad:C+cenrad); 
end    

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
    kshfts(n,1) = kstep*ceninterparr(xind(n))/subsamp;
    kshfts(n,2) = kstep*ceninterparr(yind(n))/subsamp;
    kshfts(n,3) = kstep*ceninterparr(zind(n))/subsamp;   
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

%---------------------------------------------
% Test
%---------------------------------------------
figure(102); hold on;
plot(kshfts(:,1),'b'); plot(-kshfts0(:,1),'r');
figure(103); hold on;
plot(kshfts(:,2),'b'); plot(-kshfts0(:,2),'r');
figure(104); hold on;
plot(kshfts(:,3),'b'); plot(-kshfts0(:,3),'r');

%--------------------------------------------
% Return
%--------------------------------------------
MOTCOR.DAT = DAT;
MOTCOR.Kmat = Kmat;
MOTCOR.kshfts = kshfts;
MOTCOR.magkshfts = magkshfts;
MOTCOR.stdmagkshfts = stdmagkshfts;

Status2('done','',2);
Status2('done','',3);


