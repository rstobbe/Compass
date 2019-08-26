%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = MultiFileLoad_v1a_NumFileSel(SCRPTipt,SCRPTGBL)

Status2('busy','Multiple File Load',3);

err.flag = 0;
err.msg = '';

global MULTIFILELOAD

answer = inputdlg('How Many Files?','Multiple File Load');
MULTIFILELOAD.numfiles = str2double(answer{1});

RWSUI = SCRPTGBL.RWSUI;
PanelScriptUpdate_B9(RWSUI.curpanipt-1,RWSUI.panel,RWSUI.panelnum);

SCRPTipt = LabelGet_B9(RWSUI.panel);
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = num2str(MULTIFILELOAD.numfiles);
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = num2str(MULTIFILELOAD.numfiles);
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;

callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
DataArr = SCRPTGBL.([callingfuncs{1},'_Data']);

for n = 1:MULTIFILELOAD.numfiles
    if isfield(DataArr,['File',num2str(n),'_Data'])
        Data = DataArr.(['File',num2str(n),'_Data']);
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt+n).entrystr = Data.label;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt+n).entrystruct.entrystr = Data.label;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt+n).entrystruct.altval = 1;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt+n).entrystruct.selectedfile = Data.loc;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt+n).entrystruct.('LoadMatFileCur_v4').curloc = Data.path;       
    end
end  

for n = MULTIFILELOAD.numfiles+1:50
    if isfield(DataArr,['File',num2str(n),'_Data'])
        DataArr = rmfield(DataArr,['File',num2str(n),'_Data']);
    end
end  

SCRPTGBL.([callingfuncs{1},'_Data']) = DataArr;