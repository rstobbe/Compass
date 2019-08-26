%====================================================
% (v1a)
%    
%====================================================

function [SCRPTipt,ELIP,err] = ElipManualSelection_v1a(SCRPTipt,ELIPipt)

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
