%====================================================
% (v1a)
%      
%====================================================


function [SCRPTipt,TEST,err] = TrajTest_TpiImplement_v1a(SCRPTipt,TESTipt) 

Status('busy','Get Trajectory Testing Info');
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TEST.method = TESTipt.Func;
TEST.figloc = TESTipt.('FigureLoc');

Status2('done','',2);
Status2('done','',3);










