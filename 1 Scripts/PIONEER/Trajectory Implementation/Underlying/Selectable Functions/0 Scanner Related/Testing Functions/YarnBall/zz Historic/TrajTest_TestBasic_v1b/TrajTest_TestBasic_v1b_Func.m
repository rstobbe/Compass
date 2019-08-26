%====================================================
% 
%====================================================

function [TST,err] = TrajTest_TestBasic_v1b_Func(TST,INPUT)

err.flag = 0;
err.msg = '';

TST.testing = 'Yes';
TST.testspeed = 'Standard';
TST.traj = 'TestSet';

TST.DESOL.Vis = 'No';
TST.CACC.Vis = 'ProfOnly';
TST.SYSRESP.Vis = 'No';
TST.SOLFINTEST.Vis = 'No';
TST.IMPTYPE.Vis = 'No';
TST.GVis = 'No';
TST.KVis = 'No';

if strcmp(TST.figloc,'Centre')
    TST.figshift = 0;
elseif strcmp(TST.figloc,'Left')
    TST.figshift = -1920;    
elseif strcmp(TST.figloc,'Right')
    TST.figshift = 1920;
end

Status('done','');
Status2('done','',2);
Status2('done','',3);

