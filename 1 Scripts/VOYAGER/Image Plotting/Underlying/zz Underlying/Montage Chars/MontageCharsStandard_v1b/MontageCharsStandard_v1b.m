%=========================================================
% (v1b) 
%    - use underlying function
%=========================================================

function [SCRPTipt,MCHRS,err] = MontageCharsStandard_v1b(SCRPTipt,MCHRSipt)

Status2('busy','Return Montage Image Chars',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MCHRS.method = MCHRSipt.Func;





