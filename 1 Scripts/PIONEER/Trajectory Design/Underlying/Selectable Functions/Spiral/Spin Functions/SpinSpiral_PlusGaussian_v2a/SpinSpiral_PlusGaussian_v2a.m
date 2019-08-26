%====================================================
% (v2a)
%     - start SpinSpiral_Uniform_v2a 
%====================================================

function [SCRPTipt,SPIN,err] = SpinSpiral_PlusGaussian_v2a(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN.method = SPINipt.Func;
SPIN.GblSamp = str2double(SPINipt.('GblSampFact'));
SPIN.CenSamp = str2double(SPINipt.('CenSampFact'));
SPIN.beta = str2double(SPINipt.('Beta'));

Status2('done','',2);
Status2('done','',3);
