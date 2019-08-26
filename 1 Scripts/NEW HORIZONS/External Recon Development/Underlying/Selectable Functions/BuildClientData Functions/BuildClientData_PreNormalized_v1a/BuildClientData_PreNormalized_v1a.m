%=========================================================
% (v1a)
%      
%=========================================================

function [SCRPTipt,BUILD,err] = BuildClientData_PreNormalized_v1a(SCRPTipt,BUILDipt)

Status2('busy','Get Orientation Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
BUILD.method = BUILDipt.Func;

Status2('done','',2);
Status2('done','',3);


