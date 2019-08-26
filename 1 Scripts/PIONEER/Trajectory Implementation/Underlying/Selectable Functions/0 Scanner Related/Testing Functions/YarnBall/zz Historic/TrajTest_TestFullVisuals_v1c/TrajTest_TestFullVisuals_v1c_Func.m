%====================================================
% 
%====================================================

function [TST,err] = TrajTest_TestFullVisuals_v1c_Func(TST,INPUT)

err.flag = 0;
err.msg = '';

TST.testing = 'Yes';
TST.testspeed = 'Standard';
TST.traj = 'TestSet';

TST.DESOL.Vis = 'No';
TST.CACC.Vis = 'Yes';
TST.SYSRESP.Vis = 'Yes';
TST.SOLFINTEST.Vis = 'Yes';
TST.IMPTYPE.Vis = 'Yes';
TST.GVis = 'Yes';
TST.KVis = 'Yes';

if strcmp(TST.figloc,'Centre')
    TST.figshift = 0;
elseif strcmp(TST.figloc,'Left')
    TST.figshift = -1920;    
elseif strcmp(TST.figloc,'Right')
    TST.figshift = 1920;
end

TST.savelots = 'Yes';

Status('done','');
Status2('done','',2);
Status2('done','',3);

