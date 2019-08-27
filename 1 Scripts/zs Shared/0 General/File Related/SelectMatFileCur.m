%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectMatFileCur(SCRPTipt,SCRPTGBL)

Status('busy','Select Mat File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Extension = '*.mat*';
INPUT.CurFunc = 'SelectMatFileCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'MatFile';
INPUT.AssignPath = 'Yes';

[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);

Status('done','');
Status2('done','',2); 
Status2('done','',3); 