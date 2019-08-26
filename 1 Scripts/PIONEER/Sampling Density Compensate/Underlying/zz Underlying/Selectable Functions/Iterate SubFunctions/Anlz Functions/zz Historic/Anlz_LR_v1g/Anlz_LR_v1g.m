%==================================================
% (v1g)
%   - start from TPI_v1g
%==================================================

function [SCRPTipt,ANLZ,err] = Anlz_LR_v1g(SCRPTipt,ANLZipt)

Status2('busy','Get Anlyze Function Info',2);
Status2('done','',3);

err.flag = 0;
err.mgs = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
ANLZ.method = ANLZipt.Func;
ANLZ.visuals = ANLZipt.('Visuals');
ANLZ.xaxis = ANLZipt.('xAxis');