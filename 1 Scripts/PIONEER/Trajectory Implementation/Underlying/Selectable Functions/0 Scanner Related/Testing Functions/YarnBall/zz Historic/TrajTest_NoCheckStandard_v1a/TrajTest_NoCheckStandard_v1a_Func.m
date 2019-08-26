%====================================================
% 
%====================================================

function [TST,err] = TrajTest_NoCheckStandard_v1a_Func(TST,INPUT)

err.flag = 0;
err.msg = '';

TST.testing = 'Yes';
TST.testspeed = 'Standard';
TST.traj = 1;
TST.initstrght = 'No';
TST.relprojlenmeas = 'No';
TST.checks = 'No';

TST.SPIN.Vis = 'No';
TST.CACC.Vis = 'Yes';
TST.DESOL.Vis = 'No';
TST.KSMP.Vis = 'Yes';
TST.SYSRESP.Vis = 'Yes';
TST.GVis = 'Yes';
TST.KVis = 'Yes';
TST.TVis = 'Yes';

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

