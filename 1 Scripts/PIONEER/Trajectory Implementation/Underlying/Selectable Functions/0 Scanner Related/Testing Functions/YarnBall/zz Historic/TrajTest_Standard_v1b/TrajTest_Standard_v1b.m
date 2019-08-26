%====================================================
% (v1b)
%      - Now Test Set Version
%====================================================


function [SCRPTipt,TEST,err] = TrajTest_Standard_v1b(SCRPTipt,TESTipt) 

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










