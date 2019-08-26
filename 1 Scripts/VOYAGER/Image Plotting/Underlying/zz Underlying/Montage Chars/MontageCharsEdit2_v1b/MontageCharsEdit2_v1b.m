%=========================================================
% (v1b) 
%    - remove slice label
%=========================================================

function [SCRPTipt,MCHRS,err] = MontageCharsEdit2_v1b(SCRPTipt,MCHRSipt)

Status2('busy','Return Montage Image Chars',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MCHRS.method = MCHRSipt.Func;
MCHRS.orient = MCHRSipt.('Orientation');
MCHRS.rotation = MCHRSipt.('Rotation');
MCHRS.slices = str2double(MCHRSipt.('NumSlices'));
MCHRS.insets = MCHRSipt.('Inset'); 



