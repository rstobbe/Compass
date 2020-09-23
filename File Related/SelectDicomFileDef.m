%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectDicomFileDef(SCRPTipt,SCRPTGBL)

Status('busy','Select Dicom File');
Status2('done','',2); 
Status2('done','',3); 

INPUT.Extension = '*.dcm*';
INPUT.CurFunc = 'SelectDicomFileCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'DicomFile';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileDef_v5(SCRPTipt,SCRPTGBL,INPUT);

