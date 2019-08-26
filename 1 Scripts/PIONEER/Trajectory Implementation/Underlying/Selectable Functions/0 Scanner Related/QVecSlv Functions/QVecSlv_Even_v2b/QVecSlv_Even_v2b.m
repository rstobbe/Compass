%=====================================================
% (v2b)
%       -
%=====================================================

function [SCRPTipt,GQNT,err] = QVecSlv_Even_v2b(SCRPTipt,GQNTipt)

Status2('busy','Get Gradient Waveform Quantization Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GQNT.method = GQNTipt.Func;
GQNT.gseg = str2double(GQNTipt.('Gseg'));

Status2('done','',2);
Status2('done','',3);