%====================================================
% 
%====================================================

function [ORNT,err] = OrientSiemensDefault_v1a_Func(ORNT,INPUT)

Status2('busy','Define Orientation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
KSA = INPUT.KSA;
PROJdgn = INPUT.PROJdgn;
clear INPUT;

%---------------------------------------------
% Orient
%---------------------------------------------
ORNT.KSA = zeros(size(KSA));
ORNT.KSA(:,:,1) = KSA(:,:,3);
ORNT.KSA(:,:,2) = PROJdgn.elip*KSA(:,:,2);
ORNT.KSA(:,:,3) = KSA(:,:,1);
ORNT.GradMatRelation = 'ZYX';
ORNT.ReconDefault = 'Axial';
ORNT.ElipDir = 'Y';
ORNT.dimx = PROJdgn.vox;
ORNT.dimy = PROJdgn.vox/PROJdgn.elip;
ORNT.dimz = PROJdgn.vox;


Status2('done','',2);
Status2('done','',3);