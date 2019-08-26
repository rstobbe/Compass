%====================================================
% 
%====================================================

function [ORNT,err] = OrientFlexible_v1b_Func(ORNT,INPUT)

Status2('busy','Define Orientation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
KSA = INPUT.KSA;
PROJdgn = INPUT.PROJdgn;
SYS = INPUT.SYS;
clear INPUT;

%---------------------------------------------
% Orient
%---------------------------------------------
% x -> ORNT.kxyz(1)
% y -> ORNT.kxyz(2)
% z -> ORNT.kxyz(3)
%---------------------------------------------
ind1 = strfind(ORNT.kxyz,'x');
ind2 = strfind(ORNT.kxyz,'y');
ind3 = strfind(ORNT.kxyz,'z');

ORNT.KSA = zeros(size(KSA));
ORNT.KSA(:,:,1) = KSA(:,:,ind1);
ORNT.KSA(:,:,2) = KSA(:,:,ind2);
ORNT.KSA(:,:,3) = KSA(:,:,ind3);

% MaxX = max(max(KSA(:,:,1)))                             % This function assumes KSA created with elip on Z (this is a test)
% MaxY = max(max(KSA(:,:,2)))
% MaxZ = max(max(KSA(:,:,3)))

ZMap = ORNT.kxyz(3);                                               

%---------------------------------------------
% Test
%---------------------------------------------
if isfield(PROJdgn,'elip')
    elip = PROJdgn.elip;
else
    elip = 1;
end
ORNT.dimx = PROJdgn.vox;
ORNT.dimy = PROJdgn.vox;
ORNT.dimz = PROJdgn.vox; 
ORNT.dimLR = PROJdgn.vox;
ORNT.dimTB = PROJdgn.vox;   
ORNT.dimIO = PROJdgn.vox;

if strcmp(ZMap,'x')
    ORNT.dimLR = ORNT.dimLR/elip;
    ORNT.dimx = PROJdgn.vox/elip;
elseif strcmp(ZMap,'y')
    ORNT.dimTB = ORNT.dimTB/elip;
    ORNT.dimy = PROJdgn.vox/elip;
elseif strcmp(ZMap,'z')
    ORNT.dimIO = ORNT.dimIO/elip;
    ORNT.dimz = PROJdgn.vox/elip;
end

%---------------------------------------------
% Finish
%---------------------------------------------
ORNT.PhysMatRelation = SYS.PhysMatRelation;

Status2('done','',2);
Status2('done','',3);