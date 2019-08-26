%===============================================
% (v1e)
%       - break on increasing error
%===============================================

function [SCRPTipt,BRK,err] = Break_Iterations_v1e(SCRPTipt,BRKipt)

Status2('done','Test for Stopping Criteria',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
BRK.itnum = str2double(BRKipt.('ItNum'));




