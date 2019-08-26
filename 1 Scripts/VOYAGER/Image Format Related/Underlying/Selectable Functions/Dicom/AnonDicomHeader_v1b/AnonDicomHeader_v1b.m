%====================================================
% (v1b)
%
%====================================================

function [SCRPTipt,ANON,err] = AnonDicomHeader_v1b(SCRPTipt,ANONipt)

Status('busy','Anonomize Dicoms');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
ANON.method = ANONipt.Func;
ANON.val = ANONipt.('AnonVal');


Status('done','');
Status2('done','',2);
Status2('done','',3);