%=========================================================
% (v1e)
%       - update for function splitting
%=========================================================

function [SCRPTipt,QVEC,err] = QVec_TPI_v1e(SCRPTipt,QVECipt)

Status2('busy','Get Solve Quantization Vector Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
QVEC.method = QVECipt.Func;
QVEC.timebase = str2double(QVECipt.('timebase'))/1000;

Status2('done','',2);
Status2('done','',3);