%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectDicomFileCur(SCRPTipt,SCRPTGBL)

Status('busy','Select Dicom File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Extension = '*.dcm*';
INPUT.CurFunc = 'SelectDicomFileCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'DicomFile';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);

Status('done','');
Status2('done','',2); 
Status2('done','',3); 