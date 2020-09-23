%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = MultiScriptSelect_v1a_NumFileSel(SCRPTipt,SCRPTGBL)

Status2('busy','Select Number of Scripts',1);

err.flag = 0;
err.msg = '';

global MULTIFILELOAD

answer = inputdlg('How Many Scripts?','Multiple Script Select');
if isempty(answer)
    err.flag = 4;
    err.msg = 'Return';
    return
end
MULTIFILELOAD.numfiles = str2double(answer{1});

RWSUI = SCRPTGBL.RWSUI;
PanelScriptUpdate_B9(RWSUI.curpanipt-1,RWSUI.tab,RWSUI.panelnum);

SCRPTipt = LabelGet(RWSUI.tab,RWSUI.panelnum);
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = num2str(MULTIFILELOAD.numfiles);
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = num2str(MULTIFILELOAD.numfiles);
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;

