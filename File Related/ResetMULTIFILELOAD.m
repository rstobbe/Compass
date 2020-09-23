%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ResetMULTIFILELOAD(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

global MULTIFILELOAD
MULTIFILELOAD.numfiles = 0;
RWSUI = SCRPTGBL.RWSUI;
PanelScriptUpdate_B9(RWSUI.curpanipt-1,RWSUI.tab,RWSUI.panelnum);
SCRPTipt = LabelGet(RWSUI.tab,RWSUI.panelnum);