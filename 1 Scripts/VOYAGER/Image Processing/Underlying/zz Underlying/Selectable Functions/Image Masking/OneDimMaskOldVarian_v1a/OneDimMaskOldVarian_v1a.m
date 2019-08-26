%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,MASK,err] = OneDimMask_v1a(SCRPTipt,MASKipt)

Status2('busy','Image Masking',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
MASK.method = MASKipt.Func;
MASK.width = str2double(MASKipt.('Width'));
MASK.displace = str2double(MASKipt.('Displace'));
MASK.direction = MASKipt.('Direction');
MASK.orient = MASKipt.('Plot_Orient');

Status2('done','',2);
Status2('done','',3);

