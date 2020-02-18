%====================================================
% 
%====================================================

function [ORNT,err] = OrientTpiHippo_v1a_Func(ORNT,INPUT)

Status2('busy','Define Orientation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
KSA0 = INPUT.KSA;
PROJdgn = INPUT.PROJdgn;
SYS = INPUT.SYS;
clear INPUT;

%---------------------------------------------
% Elip
%---------------------------------------------
KSA0(:,:,3) = KSA0(:,:,3)*PROJdgn.elip;

%---------------------------------------------
% Orient
%---------------------------------------------
KSA01 = zeros(size(KSA0));
KSA01(:,:,1) = KSA0(:,:,1);               % coronal by default
KSA01(:,:,2) = KSA0(:,:,3);
KSA01(:,:,3) = KSA0(:,:,2);  

KSA = zeros(size(KSA01));
thx = (pi*ORNT.hippoangle/180);
Rx=[1 0 0;
    0 cos(thx) -sin(thx);
    0 sin(thx) cos(thx)];
sz = size(KSA0);
for n = 1:sz(1)
    KSA(n,:,:) = squeeze(KSA01(n,:,:))*Rx;
end
ORNT.KSA = KSA;
ORNT.rotmat = Rx;

%---------------------------------------------
% Assign Resolution
%---------------------------------------------
if isfield(PROJdgn,'elip')
    elip = PROJdgn.elip;
else
    elip = 1;
end

ORNT.dimx = PROJdgn.vox;                     
ORNT.dimy = PROJdgn.vox/elip;  
ORNT.dimz = PROJdgn.vox;
    
ORNT.PhysMatRelation = SYS.PhysMatRelation;
ORNT.dimLR = ORNT.dimx;                                  % should take 'PhysMatRelation' into account (now assuming Prisma...)
ORNT.dimTB = ORNT.dimy;   
ORNT.dimIO = ORNT.dimz; 

ORNT.ElipDim = 2;

Status2('done','',2);
Status2('done','',3);