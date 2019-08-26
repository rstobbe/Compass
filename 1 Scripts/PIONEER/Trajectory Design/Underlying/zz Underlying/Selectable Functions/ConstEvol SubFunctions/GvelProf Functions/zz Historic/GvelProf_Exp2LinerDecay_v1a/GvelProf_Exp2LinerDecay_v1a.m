%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,CACCP,err] = GvelProf_Exp2LinerDecay_v1a(SCRPTipt,CACCPipt)

Status2('done','Gradient Velocity Profile',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CACCP.method = CACCPipt.Func;  
CACCP.tau = str2double(CACCPipt.('tau'));
CACCP.decaystart = str2double(CACCPipt.('decaystart'));
CACCP.decayrate = str2double(CACCPipt.('decayrate'));

Status2('done','',3);