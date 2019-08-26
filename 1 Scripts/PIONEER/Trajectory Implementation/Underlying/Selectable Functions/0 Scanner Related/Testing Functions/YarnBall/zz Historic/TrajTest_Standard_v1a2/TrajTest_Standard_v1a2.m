%====================================================
% (v1a2)
%      - For a while existed with 'TestSet' output
%       (even though Traj = 1 selected)
%      - used numeric value of string 'TestSet' to select trajectory
%====================================================


function [SCRPTipt,TEST,err] = TrajTest_Standard_v1a2(SCRPTipt,TESTipt) 

Status('busy','Get Trajectory Testing Info');
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TEST.method = TESTipt.Func;
TEST.traj = TESTipt.('TestTraj');

Status2('done','',2);
Status2('done','',3);










