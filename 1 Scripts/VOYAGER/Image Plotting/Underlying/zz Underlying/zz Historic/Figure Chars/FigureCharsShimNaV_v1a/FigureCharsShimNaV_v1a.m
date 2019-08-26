%=========================================================
% (v1a) 
%    
%=========================================================

function [SCRPTipt,FCHRS,err] = FigureCharsShimV_v1a(SCRPTipt,FCHRSipt)

Status2('busy','Return Figure Chars',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FCHRS.method = FCHRSipt.Func;




