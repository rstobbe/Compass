%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,BLOCH,err] = StandardBloch_v1a(SCRPTipt,BLOCHipt)

Status2('done','Bloch Excitation Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
BLOCH.method = BLOCHipt.Func; 

Status2('done','',2);
Status2('done','',3);
