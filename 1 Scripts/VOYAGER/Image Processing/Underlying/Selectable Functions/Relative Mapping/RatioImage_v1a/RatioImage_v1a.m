%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,RATIO,err] = RatioImage_v1a(SCRPTipt,RATIOipt)

Status2('done','Ratio Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
RATIO.method = RATIOipt.Func;
RATIO.maskval = str2double(RATIOipt.('Mask'));
RATIO.dir = RATIOipt.('Dir');
RATIO.type = RATIOipt.('Type');

Status2('done','',2);
Status2('done','',3);


