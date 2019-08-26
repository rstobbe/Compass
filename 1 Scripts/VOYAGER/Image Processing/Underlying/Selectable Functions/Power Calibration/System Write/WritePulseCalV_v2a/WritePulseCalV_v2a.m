%=========================================================
% (v2a)
%       - write to 'pulsecaltemp' in sodium
%=========================================================

function[SCRPTipt,SCRPTGBL,WRTSYS,err] = WritePulseCalV_v2a(SCRPTipt,SCRPTGBL,WRTSYSipt,RWSUI)

Status2('busy','Write PulseCal File (Varian)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
WRTSYS.method = WRTSYSipt.Func;

Status2('done','',2);
Status2('done','',3);
