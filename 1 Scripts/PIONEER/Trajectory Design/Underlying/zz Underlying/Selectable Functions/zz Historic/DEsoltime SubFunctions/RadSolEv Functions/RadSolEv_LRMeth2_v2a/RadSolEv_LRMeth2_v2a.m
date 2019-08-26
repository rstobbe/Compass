%====================================================
% (v2a)
%    - input for 'Nin' and 'OutShape'
%====================================================

function [SCRPTipt,RADEV,err] = RadSolEv_LRMeth2_v2a(SCRPTipt,RADEVipt)

Status2('done','Get Radial evolution function info',3);

err.flag = 0;
err.msg = '';

RADEV.method = RADEVipt.Func;   
RADEV.Nin = str2double(RADEVipt.('Nin'));
RADEV.OutShape = str2double(RADEVipt.('OutShape'))*1e-3;

Status2('done','',3);