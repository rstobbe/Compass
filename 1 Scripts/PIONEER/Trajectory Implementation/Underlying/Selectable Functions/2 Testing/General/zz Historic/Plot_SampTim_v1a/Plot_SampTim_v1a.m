%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_SampTim_v1a(SCRPTipt,SCRPTGBL)

errnum = 1;
err.flag = 0;
err.msg = '';

N = str2double(SCRPTipt(strcmp('TrajNum',{SCRPTipt.labelstr})).entrystr);

Testing = SCRPTGBL.Testing;

figure(5);
plot(Testing.tatr,Testing.r(N,:),'r'); xlabel('(ms)'); ylabel('Relative Radial Value');


