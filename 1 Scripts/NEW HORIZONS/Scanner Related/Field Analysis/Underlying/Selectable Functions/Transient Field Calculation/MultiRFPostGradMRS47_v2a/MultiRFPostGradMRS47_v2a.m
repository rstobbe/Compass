%====================================================
% (v2a) 
%       - as  MultiRFPostGrad_v2a (hard code)
%====================================================

function [SCRPTipt,TF,err] = MultiRFPostGradMRS47_v2a(SCRPTipt,TFipt)

Status2('busy','Get Info for Transient Field Calculation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TF.gstart = 2;
TF.gstop = 15;
TF.timestart = 'Middle of Fall';

Status2('done','',2);
Status2('done','',3);