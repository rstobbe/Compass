%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,ISHIM,err] = ShimImageIntensityLPF_v2a(SCRPTipt,ISHIMipt)

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


Status2('done','',2);
Status2('done','',3);

