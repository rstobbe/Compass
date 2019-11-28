%=========================================================
% (v1a)
%     
%=========================================================

function [SCRPTipt,COR,err] = VoxelCorrect_v1a(SCRPTipt,ORNTipt)

Status2('busy','Adjust Voxel Size',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
COR.method = ORNTipt.Func;
COR.voxscale = str2double(ORNTipt.('VoxScale'));

Status2('done','',2);
Status2('done','',3);

