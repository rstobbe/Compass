%===============================================
% (v1b)
%       - update for RWSUI_BA
%===============================================

function [SCRPTipt,ACCout,err] = Acc_Const_v1b(SCRPTipt,ACC)

Status2('done','Return Constant Acceleration',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
ACCout.acc = str2double(ACC.('ItNum'));

