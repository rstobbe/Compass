%====================================================
% 
%====================================================

function [TST,err] = TrajTest_RapidAll_v1a_Func(TST,INPUT)

err.flag = 0;
err.msg = '';

TST.testing = 'Yes';
TST.testspeed = 'Rapid';
TST.traj = 'All';
TST.initstrght = 'No';
TST.relprojlenmeas = 'No';

TST.SPIN.Vis = 'No';
TST.CACC.Vis = 'Yes';
TST.DESOL.Vis = 'No';
TST.KSMP.Vis = 'Yes';
TST.GVis = 'Yes';
TST.KVis = 'Yes';
TST.TVis = 'Yes';

Status('done','');
Status2('done','',2);
Status2('done','',3);

