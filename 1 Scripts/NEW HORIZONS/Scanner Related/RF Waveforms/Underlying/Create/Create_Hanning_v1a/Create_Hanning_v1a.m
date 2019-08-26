%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,PLS,err] = Create_Hanning_v1a(SCRPTipt,PLSipt)

Status2('busy','Create Hanning Waveform',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
PLS.method = PLSipt.Func;
PLS.lobes = str2double(PLSipt.('Lobes')); 
PLS.flip = str2double(PLSipt.('Flip')); 


Status2('done','',2);
Status2('done','',3);



