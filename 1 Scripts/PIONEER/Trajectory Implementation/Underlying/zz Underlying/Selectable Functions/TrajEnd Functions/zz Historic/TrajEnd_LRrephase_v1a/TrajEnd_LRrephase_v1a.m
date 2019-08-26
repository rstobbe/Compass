%====================================================
% (v1a)
%      
%====================================================


function [SCRPTipt,TEND,err] = TrajEnd_LRrephase_v1a(SCRPTipt,TENDipt) 

Status('busy','TrajEnd Info');
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TEND.method = TENDipt.Func;
TEND.slope = str2double(TENDipt.('EndSlp'));

Status2('done','',2);
Status2('done','',3);










