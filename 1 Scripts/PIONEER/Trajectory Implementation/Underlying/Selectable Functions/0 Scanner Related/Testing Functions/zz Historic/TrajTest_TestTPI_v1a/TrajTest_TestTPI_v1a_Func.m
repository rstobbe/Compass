%====================================================
% 
%====================================================

function [TST,err] = TrajTest_TestTPI_v1a_Func(TST,INPUT)

err.flag = 0;
err.msg = '';

TST.testing = 'Yes';
TST.testprojsubset = 'Yes';

TST.GVis = 'Yes';
TST.KVis = 'Yes';

Status('done','');
Status2('done','',2);
Status2('done','',3);

