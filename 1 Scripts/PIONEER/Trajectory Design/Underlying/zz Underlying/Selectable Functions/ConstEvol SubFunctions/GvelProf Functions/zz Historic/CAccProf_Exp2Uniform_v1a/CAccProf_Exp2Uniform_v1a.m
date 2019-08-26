%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,CACCP,err] = CAccProf_Exp2Uniform_v1a(SCRPTipt,CACCPipt)

Status2('done','Get Acceleration Profile info',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CACCP.method = CACCPipt.Func;   
CACCP.power = str2double(CACCPipt.('power'));
CACCP.tau = str2double(CACCPipt.('tau'));

Status2('done','',3);