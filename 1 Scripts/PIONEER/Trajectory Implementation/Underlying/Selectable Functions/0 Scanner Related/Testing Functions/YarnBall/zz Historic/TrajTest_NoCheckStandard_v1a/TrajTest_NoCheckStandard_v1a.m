%====================================================
% (v1a)
%      
%====================================================


function [SCRPTipt,TEST,err] = TrajTest_NoCheckStandard_v1a(SCRPTipt,TESTipt) 

Status('busy','Get Trajectory Testing Info');
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TEST.method = TESTipt.Func;
TEST.traj = str2double(TESTipt.('TestTraj'));
TEST.redraw = TESTipt.('Redraw');

Status2('done','',2);
Status2('done','',3);










