%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,GQNT,err] = QVecSlv_BasicQuantizedTPI_v1a(SCRPTipt,GQNTipt)

Status2('busy','Get Gradient Waveform Quantization Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GQNT.method = GQNTipt.Func;
GQNT.twseg = str2double(GQNTipt.('twGseg'));

Status2('done','',2);
Status2('done','',3);