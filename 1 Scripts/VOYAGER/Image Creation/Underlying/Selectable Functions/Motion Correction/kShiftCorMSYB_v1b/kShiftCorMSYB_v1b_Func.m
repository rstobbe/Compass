%=========================================================
% 
%=========================================================

function [KSHFTCOR,err] = kShiftCorMSYB_v1b_Func(KSHFTCOR,INPUT)

Status2('busy','Correct for Shifts in kSpace from Motion',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
KSMP = INPUT.KSMP;
kshfts0 = KSMP.KSHFT.kshfts;
IMP = INPUT.IMP;
arrSDC = INPUT.SDC;
arrDAT = KSMP.SampDat;
GRD = KSHFTCOR.GRD;
KSHFTCORREG = KSHFTCOR.KSHFTCORREG;
Kmat = IMP.Kmat;
clear INPUT;

%---------------------------------------------
% Get Variables
%---------------------------------------------
trajmax = KSHFTCOR.trajmax;       
kstep = IMP.impPROJdgn.kstep;
nproj = IMP.PROJimp.nproj;
npro = IMP.PROJimp.npro;
subsamp = GRD.SS;
cenrad = ceil(trajmax*subsamp);
KSHFTCOR.cenrad = cenrad;

%*********************************************
% Correct Rotation Correction Test
%*********************************************
%dotest = 0;
%if dotest == 1
%    rot0 = KSMP.ROT.rot0;
%    rotKmat = zeros(size(Kmat));
%    rotKmat(1,:,:) = Kmat(1,:,:);
%    for a = 2:nproj
%        Karr = permute(squeeze(Kmat(a,:,:)),[2 1]);
%        Karr = Rotate3DPoints_v1a(Karr,rot0(a,1),rot0(a,2),rot0(a,3));
%        rotKmat(a,:,:) = permute(Karr,[2 1]);
%    end
%    Kmat = rotKmat;
%end

%---------------------------------------------
% Compensate Data
%---------------------------------------------
arrDAT = arrDAT.*arrSDC;
[DAT] = DatArr2Mat(arrDAT,IMP.PROJimp.nproj,IMP.PROJimp.npro);

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
IMP1 = IMP;
IMP1.PROJimp.nproj = 1;
IMP1.PROJimp.npro = subnpro;
IMP1.impPROJdgn.kmax = subkmax;
GRD.type = 'complex';
INPUT.GRD = GRD;
gridfunc = str2func([KSHFTCOR.gridfunc,'_Func']);

%---------------------------------------------
% Grid Central Portion of Each Trajectory
%---------------------------------------------
kshfts = zeros(nproj,3);
for n = 1:nproj
    %-----------------------------------------
    % Isolate Each Trajectory
    DAT1 = subDAT(n,:);
    Kmat1 = subKmat(n,:,:);
    IMP1.Kmat = Kmat1;    

    %-----------------------------------------
    % Grid Each Trajectory
    INPUT.IMP = IMP1;
    INPUT.DAT = DAT1;
    [GRD,err] = gridfunc(GRD,INPUT);
    if err.flag
        return
    end
    clear INPUT
    
    %-----------------------------------------
    % Isolate Centre   
    Ksz = GRD.Ksz;
    C = (Ksz+1)/2;
    GrdDatCen = GRD.GrdDat(C-cenrad:C+cenrad,C-cenrad:C+cenrad,C-cenrad:C+cenrad);  
    
    %-----------------------------------------
    % kShift Function
    INPUT.IMP = IMP;
    INPUT.GrdDatCen = GrdDatCen;
    INPUT.cenrad = cenrad;
    INPUT.subsamp = GRD.SS;    
    func = str2func([KSHFTCOR.kshftcorregfunc,'_Func']);
    [KSHFTCORREG,err] = func(KSHFTCORREG,INPUT);
    if err.flag
        return
    end
    clear INPUT    
    kshfts(n,:) = KSHFTCORREG.kshfts;

    %---------------------------------------------
    % Test
    figure(102); hold on;
    plot(n,KSHFTCORREG.kshfts(1),'b*'); plot(-kshfts0(:,1),'bo');
    plot(n,KSHFTCORREG.kshfts(2),'r*'); plot(-kshfts0(:,2),'ro');
    plot(n,KSHFTCORREG.kshfts(3),'g*'); plot(-kshfts0(:,3),'go');
    xlabel('trajectory number'); ylabel('k-Space Shift (1/m)');    

end

%---------------------------------------------
% Calculate kShift Mag
%---------------------------------------------
magkshfts = sqrt(kshfts(:,1).^2 + kshfts(:,2).^2 + kshfts(:,3).^2);
stdmagkshfts = std(magkshfts);

%---------------------------------------------
% mean square error
%---------------------------------------------
meansqrerr = sum(sum((kshfts - kshfts0).^2))

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
KSHFTCOR.meansqrerr = meansqrerr;
KSHFTCOR.KSHFTCOR = KSHFTCORREG;

Status2('done','',2);
Status2('done','',3);


