%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectMatFileDef(SCRPTipt,SCRPTGBL)

Status('busy','Select Mat File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Extension = '*.mat*';
INPUT.CurFunc = 'SelectMatFileCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'MatFile';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileDef_v5(SCRPTipt,SCRPTGBL,INPUT);

