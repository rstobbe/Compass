%====================================================
% (v1b)
%    - Adjust VoxelStretch so elip dimension 2 sigdigs
%====================================================

function [SCRPTipt,ELIP,err] = Elip_Selection_v1b(SCRPTipt,ELIPipt)

Status2('busy','Elip Function Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ELIP.method = ELIPipt.Func;
ELIP.voxelstretch = str2double(ELIPipt.('VoxelStretch'));

Status2('done','',2);
Status2('done','',3);
