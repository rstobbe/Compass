%====================================================
% (v2a) 
%       - data input moved elsewhere
%====================================================

function [SCRPTipt,TF,err] = SingleRFPostGrad_v2a(SCRPTipt,TFipt)

Status2('busy','Get Info for Transient Field Calculation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TF.timestart = TFipt.('Timing_Start');

Status2('done','',2);
Status2('done','',3);