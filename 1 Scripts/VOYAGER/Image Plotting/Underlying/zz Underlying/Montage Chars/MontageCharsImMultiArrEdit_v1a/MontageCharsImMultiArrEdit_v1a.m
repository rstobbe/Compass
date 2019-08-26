%=========================================================
% (v1a) 
%    
%=========================================================

function [SCRPTipt,MCHRS,err] = MontageCharsImMultiArrEdit_v1a(SCRPTipt,MCHRSipt)

Status2('busy','Return Montage Image Chars',3);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MCHRS.method = MCHRSipt.Func;
MCHRS.orient = MCHRSipt.('Orientation');
MCHRS.index = MCHRSipt.('Index');
MCHRS.insets = MCHRSipt.('Inset'); 
MCHRS.ncolumns = str2double(MCHRSipt.('nColumns'));
MCHRS.Normalize = MCHRSipt.('Normalize'); 

