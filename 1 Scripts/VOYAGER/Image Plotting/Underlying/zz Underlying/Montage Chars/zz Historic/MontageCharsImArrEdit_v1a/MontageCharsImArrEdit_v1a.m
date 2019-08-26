%=========================================================
% (v1a) 
%    
%=========================================================

function [SCRPTipt,MCHRS,err] = MontageCharsImArrEdit_v1a(SCRPTipt,MCHRSipt)

Status2('busy','Return Montage Image Chars',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MCHRS.method = MCHRSipt.Func;
MCHRS.orient = MCHRSipt.('Orientation');
MCHRS.rotation = MCHRSipt.('Rotation');
MCHRS.slices = MCHRSipt.('Slices');
MCHRS.insets = MCHRSipt.('Inset'); 
MCHRS.imnum = MCHRSipt.('Arr');

%---------------------------------------------
% 
%---------------------------------------------
ind = strfind(MCHRS.imnum,',');
if isempty(ind)
    error;
else
    num1 = str2double(MCHRS.imnum(1:ind-1));
    num2 = str2double(MCHRS.imnum(ind+1:end));
    MCHRS.imnum = [num1 num2];
end
