%====================================================
% (v1b)
%     - update from 3D slope magnitude 
%====================================================


function [SCRPTipt,TEND,err] = TrajEnd_StandardSpoil_v1b(SCRPTipt,TENDipt) 

Status('busy','TrajEnd Info');
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TEND.method = TENDipt.Func;
TEND.slope = str2double(TENDipt.('EndSlp'));
TEND.spoilfactor = str2double(TENDipt.('SpoilFactor'));

Status2('done','',2);
Status2('done','',3);










