%=========================================================
% (v1a) 
%    
%=========================================================

function [SCRPTipt,FCHRS,err] = FigureCharsEdit_v1a(SCRPTipt,FCHRSipt)

Status2('busy','Return Motage Figure Chars',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FCHRS.method = FCHRSipt.Func;
FCHRS.ncolumns = str2double(FCHRSipt.('nColumns'));
FCHRS.imsize = FCHRSipt.('ImSize');
FCHRS.slclbl = FCHRSipt.('SliceLabel');
FCHRS.figno = FCHRSipt.('Figno'); 




