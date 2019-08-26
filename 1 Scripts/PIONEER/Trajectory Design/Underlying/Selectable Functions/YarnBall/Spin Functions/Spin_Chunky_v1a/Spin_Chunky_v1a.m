%====================================================
% (v1a)
%    
%====================================================

function [SCRPTipt,SPIN,err] = Spin_Chunky_v1a(SCRPTipt,SPINipt)

Status2('done','Get Spinning Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SPIN.method = SPINipt.Func;
SPIN.nspokes = str2double(SPINipt.('NumSpokes'));
SPIN.ndiscs = str2double(SPINipt.('NumDiscs'));
SPIN.AziSampSpin = str2double(SPINipt.('AziSampSpin'));
SPIN.PolSampSpin = str2double(SPINipt.('PolSampSpin'));

Status2('done','',2);
Status2('done','',3);
