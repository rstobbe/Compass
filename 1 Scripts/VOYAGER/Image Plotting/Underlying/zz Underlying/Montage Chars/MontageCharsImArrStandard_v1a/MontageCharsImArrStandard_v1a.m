%=========================================================
% (v1a) 
%    
%=========================================================

function [SCRPTipt,MCHRS,err] = MontageCharsImArrStandard_v1a(SCRPTipt,MCHRSipt)

Status2('busy','Return Montage Image Chars',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MCHRS.method = MCHRSipt.Func;
MCHRS.imnum = MCHRSipt.('ImageNum');

%---------------------------------------------
% 
%---------------------------------------------
ind = strfind(MCHRS.imnum,',');
if isempty(ind)
    MCHRS.imnum = str2double(MCHRS.imnum);
else
    num1 = str2double(MCHRS.imnum(1:ind-1));
    num2 = str2double(MCHRS.imnum(ind+1:end));
    MCHRS.imnum = [num1 num2];
end
