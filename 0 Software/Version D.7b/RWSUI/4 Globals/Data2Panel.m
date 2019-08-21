%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Data2Panel(SCRPTipt,SCRPTGBL,CallingFunc,PanelLabel,Data,Button)

err.flag = 0;
err.msg = '';
global SCRPTPATHS
RWSUI = SCRPTGBL.RWSUI;

%---------------------------------------------
% Update Panel
%---------------------------------------------
inds = strcmp(PanelLabel,{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = Data.label;
SCRPTipt(indnum).entrystruct.entrystr = Data.label;
SCRPTipt(indnum).entrystruct.altval = 1;
SCRPTipt(indnum).entrystruct.selectedfile = [Data.path,Data.file];
SCRPTipt(indnum).entrystruct.selectedpath = Data.path;
SCRPTipt(indnum).entrystruct.filename = strtok(Data.file,'.');
SCRPTipt(indnum).entrystruct.(Button).curloc = Data.path; 
if RWSUI.panelnum ~= 0
    SCRPTPATHS.(RWSUI.tab)(RWSUI.panelnum).outloc = Data.path;
end
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,RWSUI.tab,RWSUI.panelnum);

%---------------------------------------------
% Write Panel Global
%---------------------------------------------
if isempty(CallingFunc)
    SCRPTGBL.([PanelLabel,'_Data']) = Data;
else 
    SCRPTGBL.([CallingFunc,'_Data']).([PanelLabel,'_Data']) = Data;
end
% Note.. doesn't handle level 3 calling


