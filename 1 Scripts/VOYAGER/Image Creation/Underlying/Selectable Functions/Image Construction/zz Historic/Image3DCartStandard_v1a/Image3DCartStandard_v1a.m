%=========================================================
% (v1a) 
%     
%=========================================================

function [SCRPTipt,IC,err] = Image3DCartStandard_v1a(SCRPTipt,ICipt)

Status2('busy','Get Info for Image Creation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
IC.method = ICipt.Func;
IC.zf = str2double(ICipt.('ZeroFill'));

Status2('done','',2);
Status2('done','',3);

