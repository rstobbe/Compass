%=========================================================
% (v1a) 
%    
%=========================================================

function [SCRPTipt,MCHRS,err] = MontageCharsImArrEdit2_v1b(SCRPTipt,MCHRSipt)

Status2('busy','Return Montage Image Chars',3);
Status2('done','',2);

err.flag = 0;
err.msg = '';

error;  % not finished

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
