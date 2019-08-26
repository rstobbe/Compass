%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,OB,err] = FixedBox_v1a(SCRPTipt,OBipt)

Status2('done','Object Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
OB.method = OBipt.Func;
OB.fov = str2double(OBipt.('FoV'));
OB.x = str2double(OBipt.('x'));
OB.y = str2double(OBipt.('y'));
OB.z = str2double(OBipt.('z'));

Status2('done','',2);
Status2('done','',3);

