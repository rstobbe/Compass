%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,CACCP,err] = CAccProf_Exp2Decay2_v1a(SCRPTipt,CACCPipt)

Status2('done','Get Acceleration Profile info',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CACCP.method = CACCPipt.Func;  
CACCP.tau = str2double(CACCPipt.('tau'));
CACCP.startfrac = str2double(CACCPipt.('startfrac'));
CACCP.decayrate = str2double(CACCPipt.('decayrate'));
CACCP.decayshift = str2double(CACCPipt.('decayshift'));
CACCP.enddrop = str2double(CACCPipt.('enddrop'));

Status2('done','',3);