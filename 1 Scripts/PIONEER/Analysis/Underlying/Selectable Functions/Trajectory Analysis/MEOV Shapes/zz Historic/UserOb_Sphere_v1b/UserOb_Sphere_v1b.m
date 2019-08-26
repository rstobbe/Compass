%===========================================
% (v1b)
%    - remove FoV as input
%===========================================

function [SCRPTipt,OB,err] = UserOb_Sphere_v1b(SCRPTipt,OBipt)

Status2('done','Object Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
OB.method = OBipt.Func;
OB.diam = str2double(OBipt.('Diam'));

Status2('done','',2);
Status2('done','',3);

