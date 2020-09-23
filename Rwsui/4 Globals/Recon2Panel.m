%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Recon2Panel(SCRPTipt,SCRPTGBL,CallingFunc,PanelLabel,Data)

Button = 'LoadTrajImpCur';
[SCRPTipt,SCRPTGBL,err] = Data2Panel(SCRPTipt,SCRPTGBL,CallingFunc,PanelLabel,Data,Button);

