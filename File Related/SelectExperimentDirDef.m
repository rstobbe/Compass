%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectExperimentDirDef(SCRPTipt,SCRPTGBL)

INPUT.CurFunc = 'SelectExperimentDirCur';
INPUT.LoadLoc = 'experimentsloc';
[SCRPTipt,SCRPTGBL,err] = SelectDirDef_v5(SCRPTipt,SCRPTGBL,INPUT);

