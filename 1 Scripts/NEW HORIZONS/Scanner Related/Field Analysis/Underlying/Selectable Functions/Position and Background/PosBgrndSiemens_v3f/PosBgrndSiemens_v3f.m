%====================================================
% (v3f) 
%       - add figure saving capability
%====================================================

function [SCRPTipt,POSBG,err] = PosBgrndSiemens_v3f(SCRPTipt,POSBGipt)

Status2('busy','Get Info for Postition and Background Field Calculation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
POSBG.method = POSBGipt.Func;
POSBG.plstart = str2double(POSBGipt.PLstart);
POSBG.plstop = str2double(POSBGipt.PLstop);
POSBG.bgstart = str2double(POSBGipt.BGstart);
POSBG.bgstop = POSBGipt.BGstop;

Status2('done','',2);
Status2('done','',3);

