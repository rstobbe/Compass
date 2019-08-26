%====================================================
% 
%====================================================

function [ORNT,err] = OrientFlexible_v1a_Func(ORNT,INPUT)

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
% Test
%---------------------------------------------
if PROJdgn.elip ~= 1
    error;                              % not included yet... in future add another option for its direction
end
ORNT.dimx = PROJdgn.vox;
ORNT.dimy = PROJdgn.vox;
ORNT.dimz = PROJdgn.vox;
ORNT.dimLR = PROJdgn.vox;
ORNT.dimTB = PROJdgn.vox;   
ORNT.dimIO = PROJdgn.vox;

%---------------------------------------------
% Orient
%---------------------------------------------
ind1 = strfind(ORNT.kxyz,'x');
ind2 = strfind(ORNT.kxyz,'y');
ind3 = strfind(ORNT.kxyz,'z');

ORNT.KSA = zeros(size(KSA));
ORNT.KSA(:,:,1) = KSA(:,:,ind1);
ORNT.KSA(:,:,2) = KSA(:,:,ind2);
ORNT.KSA(:,:,3) = KSA(:,:,ind3);

%---------------------------------------------
% Finish
%---------------------------------------------
ORNT.PhysMatRelation = SYS.PhysMatRelation;

Status2('done','',2);
Status2('done','',3);