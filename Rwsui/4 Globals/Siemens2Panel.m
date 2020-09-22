%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Siemens2Panel(SCRPTipt,SCRPTGBL,CallingFunc,PanelLabel,Data)

Button = 'LoadSiemensDataCur';
[SCRPTipt,SCRPTGBL,err] = Data2Panel(SCRPTipt,SCRPTGBL,CallingFunc,PanelLabel,Data,Button);

