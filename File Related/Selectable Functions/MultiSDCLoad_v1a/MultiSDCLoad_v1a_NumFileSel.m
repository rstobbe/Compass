%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = MultiSDCLoad_v1a_NumFileSel(SCRPTipt,SCRPTGBL)

Status2('busy','Multiple SDC Load',1);

err.flag = 0;
err.msg = '';

global MULTIFILELOAD

answer = inputdlg('How Many Files?','Multiple SDC Load');
if isempty(answer)
    err.flag = 4;
    err.msg = 'Return';
    return
end
MULTIFILELOAD.numfiles = str2double(answer{1});

RWSUI = SCRPTGBL.RWSUI;
PanelScriptUpdate_B9(RWSUI.curpanipt-1,RWSUI.panel,RWSUI.panelnum);

SCRPTipt = LabelGet(RWSUI.panelnum);
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = num2str(MULTIFILELOAD.numfiles);
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = num2str(MULTIFILELOAD.numfiles);
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;

callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
DataArr = SCRPTGBL.([callingfuncs{1},'_Data']);

for n = 1:MULTIFILELOAD.numfiles
    if isfield(DataArr,['SDC',num2str(n),'_Data'])
        Data = DataArr.(['SDC',num2str(n),'_Data']);
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt+n).entrystr = Data.label;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt+n).entrystruct.entrystr = Data.label;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt+n).entrystruct.altval = 1;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt+n).entrystruct.selectedfile = Data.loc;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt+n).entrystruct.('LoadSDCCur_v4').curloc = Data.path;   
        DataArr2.(['SDC',num2str(n),'_Data']) = DataArr.(['SDC',num2str(n),'_Data']);
    end
end  

SCRPTGBL.([callingfuncs{1},'_Data']) = DataArr2;