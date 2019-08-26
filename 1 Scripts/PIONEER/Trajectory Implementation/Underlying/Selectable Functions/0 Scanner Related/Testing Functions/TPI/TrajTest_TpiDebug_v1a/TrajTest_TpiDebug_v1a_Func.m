%====================================================
% 
%====================================================

function [TST,err] = TrajTest_Debug_v1a_Func(TST,INPUT)

err.flag = 0;
err.msg = '';

TST.testing = 'Yes';
TST.testspeed = 'Standard';
TST.initstrght = 'No';
TST.relprojlenmeas = 'No';
TST.testprojsubset = 'Yes';

TST.CACC.Vis = 'Yes';
TST.DESOL.Vis = 'Yes';
TST.KSMP.Vis = 'Yes';
TST.SYSRESP.Vis = 'Yes';
TST.GVis = 'Yes';
TST.KVis = 'Yes';
TST.TVis = 'Yes';

Status('done','');
Status2('done','',2);
Status2('done','',3);

