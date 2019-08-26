%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,ISHIM,err] = ShimImageIntensityLPF_v2b(SCRPTipt,ISHIMipt)

Status2('done','Intensity Shim Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
ISHIM.method = ISHIMipt.Func;
ISHIM.profres = str2double(ISHIMipt.('ImProfRes'));
ISHIM.proffilt = str2double(ISHIMipt.('ImProfFilt'));
ISHIM.profstretch = str2double(ISHIMipt.('ProfStrch'));
ISHIM.profrelmin = str2double(ISHIMipt.('ProfRelMin'));
ISHIM.background = ISHIMipt.('BGdisp');

Status2('done','',2);
Status2('done','',3);

