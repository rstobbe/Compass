%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,WRT,err] = Write_RFwfmV_v1a(SCRPTipt,WRTipt)

Status2('busy','Write RF waveform (Varian)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
WRT.method = WRTipt.Func;
WRT.wfmpts = str2double(WRTipt.('WfmPts')); 

Status2('done','',2);
Status2('done','',3);



