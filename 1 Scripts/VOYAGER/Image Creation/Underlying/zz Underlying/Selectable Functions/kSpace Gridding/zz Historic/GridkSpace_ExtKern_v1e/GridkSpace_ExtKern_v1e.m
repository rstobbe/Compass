%=========================================================
% (v1e) 
%       -  selectable precision / method
%=========================================================

function [SCRPTipt,GRD,err] = GridkSpace_ExtKern_v1e(SCRPTipt,GRDipt)

Status2('busy','Get Info for k-Space Gridding',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GRD.method = GRDipt.Func;

Status2('done','',2);
Status2('done','',3);


