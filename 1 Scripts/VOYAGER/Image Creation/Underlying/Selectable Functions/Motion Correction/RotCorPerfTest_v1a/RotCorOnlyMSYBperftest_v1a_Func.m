%=========================================================
% 
%=========================================================

function [MOTCOR,err] = RotCorOnlyMSYBperftest_v1a_Func(MOTCOR,INPUT)

Status2('busy','Perfectly Correct for Rotation (MSYB)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DAT = INPUT.DAT;
KSMP = INPUT.KSMP;
rot0 = KSMP.ROT.rot0;
IMP = INPUT.IMP;
Kmat = IMP.Kmat;
clear INPUT;

%---------------------------------------------
% Variables
%---------------------------------------------
nproj = IMP.PROJimp.nproj;

%---------------------------------------------
% Correct Trajectories
%---------------------------------------------
rotKmat = zeros(size(Kmat));
rotKmat(1,:,:) = Kmat(1,:,:);
for a = 2:nproj
    Karr = permute(squeeze(Kmat(a,:,:)),[2 1]);
    Karr = Rotate3DPoints_v1a(Karr,rot0(a,1),rot0(a,2),rot0(a,3));
    rotKmat(a,:,:) = permute(Karr,[2 1]);
    figure(400); hold on;
    plot(a,rot0(a,1),'bo');
    plot(a,rot0(a,2),'ro');
    plot(a,rot0(a,3),'go');
end

%--------------------------------------------
% Return
%--------------------------------------------
MOTCOR.DAT = DAT;
MOTCOR.Kmat = rotKmat;

Status2('done','',2);
Status2('done','',3);


