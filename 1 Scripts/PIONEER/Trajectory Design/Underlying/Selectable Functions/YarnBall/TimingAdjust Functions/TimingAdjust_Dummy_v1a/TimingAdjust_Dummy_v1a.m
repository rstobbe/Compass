%====================================================
% (v1a)
%   - 
%====================================================

function [SCRPTipt,TIMADJ,err] = TimingAdjust_Dummy_v1a(SCRPTipt,TIMADJipt)

Status2('busy','Get Timing Adjust',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
TIMADJ.method = TIMADJipt.Func;   

Status2('done','',3);