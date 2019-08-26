%====================================================
% (v1a)
%     
%====================================================


function [SCRPTipt,REVO,err] = Rad3DEvo_RampFlat_v1a(SCRPTipt,REVOipt) 

Status('busy','Radial Evolution Ramp-Flat');
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
REVO.ramp = str2double(REVOipt.('Ramp'));
REVO.method = REVOipt.Func;

Status2('done','',2);
Status2('done','',3);










