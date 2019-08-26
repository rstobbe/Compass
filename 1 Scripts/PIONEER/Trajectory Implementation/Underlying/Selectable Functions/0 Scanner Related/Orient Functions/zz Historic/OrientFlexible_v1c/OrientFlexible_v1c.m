%====================================================
% (v1c)
%    - Fix dim_xyz. Voxels should be specified as before orient
%====================================================

function [SCRPTipt,ORNT,err] = OrientFlexible_v1c(SCRPTipt,ORNTipt)

Status2('busy','Orient Function Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ORNT.method = ORNTipt.Func;
ORNT.kxyz = ORNTipt.('kxyz');

Status2('done','',2);
Status2('done','',3);
