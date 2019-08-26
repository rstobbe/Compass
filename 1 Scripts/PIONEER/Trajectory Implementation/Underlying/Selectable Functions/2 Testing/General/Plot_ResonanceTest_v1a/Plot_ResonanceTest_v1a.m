%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,PLOT,err] = Plot_ResonanceTest_v1a(SCRPTipt,PLOTipt)

Status2('busy','Plot Resonance Test',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
PLOT.method = PLOTipt.Func;
PLOT.TR = str2double(PLOTipt.('TR'));

Status2('done','',2);
Status2('done','',3);

