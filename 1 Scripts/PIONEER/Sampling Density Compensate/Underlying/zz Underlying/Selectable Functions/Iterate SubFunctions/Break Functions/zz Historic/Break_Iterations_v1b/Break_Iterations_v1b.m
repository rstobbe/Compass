%===============================================
% (v1b)
%       - update for RWSUI_BA
%===============================================

function [SCRPTipt,BRKout,err] = Break_Iterations_v1b(SCRPTipt,BRK)

Status2('done','Test for Stopping Criteria',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
BRKout.itnum = str2double(BRK.('ItNum'));

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
j = BRK.j;

%---------------------------------------------
% Test for Stopping
%---------------------------------------------
if j == BRKout.itnum
    BRKout.stop = 1;
    BRKout.stopreason = 'Objective Reached';
else
    BRKout.stop = 0;
end


