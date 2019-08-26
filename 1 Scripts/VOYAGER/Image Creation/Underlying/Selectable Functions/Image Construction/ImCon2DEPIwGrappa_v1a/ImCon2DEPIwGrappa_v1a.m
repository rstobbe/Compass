%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,IC,err] = ImCon2DEPIwGrappa_v1a(SCRPTipt,ICipt)

Status2('busy','Create 2D Cartesian Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
IC.method = ICipt.Func;

Status2('done','',2);
Status2('done','',3);




