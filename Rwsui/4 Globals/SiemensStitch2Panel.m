%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SiemensStitch2Panel(SCRPTipt,SCRPTGBL,CallingFunc,PanelLabel,Data)

Button = 'LoadSiemensDataCurStitch';
[SCRPTipt,SCRPTGBL,err] = Data2Panel(SCRPTipt,SCRPTGBL,CallingFunc,PanelLabel,Data,Button);

