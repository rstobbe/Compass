%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Global2Panel(SCRPTipt,SCRPTGBL,CallingFunc,PanelLabel,LoadType,Path,File,saveData)

err.flag = 0;
err.msg = '';
global SCRPTPATHS
RWSUI = SCRPTGBL.RWSUI;

%---------------------------------------------
% Test
%---------------------------------------------
if iscell(File)
    File = File{1};
end

%------------------------------------------
% Create Label
%------------------------------------------
DropExt = 'No';
[label] = TruncFileNameForDisp_v1([Path,File],DropExt);

%---------------------------------------------
% Associate Loading Type
%---------------------------------------------
loadfunc = '';
if strcmp(LoadType,'Image')
    loadfunc = 'LoadImageCur';
end

%---------------------------------------------
% Update Panel
%---------------------------------------------
inds = strcmp(PanelLabel,{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = label;
SCRPTipt(indnum).entrystruct.entrystr = label;
SCRPTipt(indnum).entrystruct.altval = 1;
SCRPTipt(indnum).entrystruct.selectedfile = [Path,File];
SCRPTipt(indnum).entrystruct.(loadfunc).curloc = Path; 
if RWSUI.panelnum ~= 0
    SCRPTPATHS.(RWSUI.tab)(RWSUI.panelnum).outloc = Path;
end
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,RWSUI.tab,RWSUI.panelnum);

%---------------------------------------------
% Write Panel Global
%---------------------------------------------
if isempty(CallingFunc)
    SCRPTGBL.([PanelLabel,'_Data']) = saveData;
else 
    SCRPTGBL.([CallingFunc,'_Data']).([PanelLabel,'_Data']) = saveData;
end
% Note.. doesn't handle level 3 calling


