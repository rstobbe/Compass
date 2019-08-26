%====================================================
% (v1a)
%     
%====================================================

function [SCRPTipt,CACCP,err] = GvelProf_Exp2Uniform_v1a(SCRPTipt,CACCPipt)

Status2('done','Get Gslew Profile info',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CACCP.method = CACCPipt.Func;  
CACCP.tau = str2double(CACCPipt.('tau'));
CACCP.startfrac = 100;
CACCP.decayrate = 0;
CACCP.decayshift = 0;
CACCP.enddrop = 0;

Status2('done','',3);