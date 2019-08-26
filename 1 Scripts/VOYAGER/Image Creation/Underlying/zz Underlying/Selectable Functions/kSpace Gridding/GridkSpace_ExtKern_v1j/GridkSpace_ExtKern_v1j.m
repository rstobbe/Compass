%=========================================================
% (v1j) 
%  - no more 'Precision' and 'Implement' selections
%      (always CUDA & double)
%=========================================================

function [SCRPTipt,GRD,err] = GridkSpace_ExtKern_v1j(SCRPTipt,GRDipt)

Status2('busy','Get Info for k-Space Gridding',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GRD.method = GRDipt.Func;

Status2('done','',2);
Status2('done','',3);

