%===========================================
% (v1a)
%    - 
%===========================================

function [SCRPTipt,OB,err] = UserOb_SphereOnOffset_v1a(SCRPTipt,OBipt)

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

