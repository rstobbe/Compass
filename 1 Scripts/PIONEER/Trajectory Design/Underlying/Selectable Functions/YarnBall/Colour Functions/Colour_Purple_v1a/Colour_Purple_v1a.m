%====================================================
% (v1a)
%   
%====================================================

function [SCRPTipt,CLR,err] = Colour_Purple_v1a(SCRPTipt,CLRipt)

Status2('busy','Get Colour',3);

err.flag = 0;
err.msg = '';

CLR.method = CLRipt.Func;   
CLR.centrespinfact = str2double(CLRipt.('CentreSpinFact'));
CLR.spawnfact = str2double(CLRipt.('SpawnFact'));

Status2('done','',3);