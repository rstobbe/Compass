%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = File2Panel(SCRPTipt,SCRPTGBL,CallingFunc,PanelLabel,LoadType,Path,File)

err.flag = 0;
err.msg = '';
global SCRPTPATHS
global RWSUIGBL
RWSUI = SCRPTGBL.RWSUI;

%---------------------------------------------
% Test
%---------------------------------------------
if iscell(File)
    File = File{1};
end

%---------------------------------------------
% Create Label
%---------------------------------------------
name = [Path,File];
label = name;
if length(label) > RWSUIGBL.fullwid
    ind = strfind(name,filesep);
    n = 1;
    while true
        label = ['...',name(ind(n)+1:length(name))];
        if length(label) <= RWSUIGBL.fullwid
            break
        end
        n = n+1;
    end
end

%---------------------------------------------
% Associate Loading Type
%---------------------------------------------
loadfunc = '';
if strcmp(LoadType,'Image')
    loadfunc = 'LoadImageCur';
elseif strcmp(LoadType,'FID')
    loadfunc = 'SelectFidDataCur_v4b';    
elseif strcmp(LoadType,'Directory')
    loadfunc = 'SelectDirCur_v4';   
end

%---------------------------------------------
% Update Panel
%---------------------------------------------
inds = strcmp(PanelLabel,{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = label;
SCRPTipt(indnum).entrystruct.entrystr = label;
SCRPTipt(indnum).entrystruct.altval = 1;
SCRPTipt(indnum).entrystruct.selectedfile = name;
SCRPTipt(indnum).entrystruct.(loadfunc).curloc = Path; 
if RWSUI.panelnum ~= 0   
    SCRPTPATHS(RWSUI.panelnum).outPath = Path;
    setfunc = 1;
    DispScriptParam(SCRPTipt,setfunc,RWSUI.tab,RWSUI.panelnum);
end

%---------------------------------------------
% Load File
%---------------------------------------------
if strcmp(LoadType,'File')
    load(name);
elseif strcmp(LoadType,'Image')
    [IMG,~,~,err] = Import_Image(name,'');
    saveData.IMG = IMG;
    saveData.file = file;
end
saveData.path = Path;

%---------------------------------------------
% Write Panel Global
%---------------------------------------------
if isempty(CallingFunc)
    SCRPTGBL.([PanelLabel,'_Data']) = saveData;
else 
    SCRPTGBL.([CallingFunc,'_Data']).([PanelLabel,'_Data']) = saveData;
end
% Note.. doesn't handle level 3 calling


