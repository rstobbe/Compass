%====================================================
% 
%====================================================

function [TST,err] = TrajTest_Standard_v1b_Func(TST,INPUT)

err.flag = 0;
err.msg = '';

TST.testing = 'Yes';
TST.testspeed = 'Standard';
TST.traj = 1;
%TST.traj = 'TestSet';
TST.initstrght = 'No';
TST.relprojlenmeas = 'No';
TST.checks = 'asdfh';

TST.CACC.Vis = 'No';
%TST.CACC.Vis = 'ProfOnly';
TST.DESOL.Vis = 'No';
TST.SYSRESP.Vis = 'No';
TST.SOLFINTEST.Vis = 'No';
TST.IMPTYPE.Vis = 'Yes';
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

