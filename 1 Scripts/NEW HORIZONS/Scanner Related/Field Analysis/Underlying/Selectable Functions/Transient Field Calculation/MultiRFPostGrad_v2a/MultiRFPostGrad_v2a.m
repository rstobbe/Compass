%====================================================
% (v2a) 
%       - data input moved elsewhere
%====================================================

function [SCRPTipt,TF,err] = MultiRFPostGrad_v2a(SCRPTipt,TFipt)

Status2('busy','Get Info for Transient Field Calculation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TF.gstart = str2double(TFipt.('Gstart'));
TF.gstop = str2double(TFipt.('Gstop'));
TF.timestart = TFipt.('Timing_Start');

Status2('done','',2);
Status2('done','',3);