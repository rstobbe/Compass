%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT)

global SCRPTPATHS
global RWSUIGBL

tab = SCRPTGBL.RWSUI.tab;
err.flag = 0;
err.msg = '';
saveData = [];

%------------------------------------------
% Determine Select Location
%------------------------------------------
Struct = SCRPTGBL.CurrentScript.Struct;
Func = SCRPTGBL.CurrentScript.Func;
if isempty(RWSUIGBL.Key)
    curloc = Struct.(Func).curloc;
elseif strcmp(RWSUIGBL.Key,'shift')
    if strcmp(INPUT.Type,'ScanData')
        curloc = SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).experimentsloc;        
    else
        curloc = SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc;
    end
elseif strcmp(RWSUIGBL.Key,'control')
    path = uigetdir(Struct.(Func).curloc,'Select Search Directory');
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(INPUT.CurFunc).curloc = path;
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = '';
    SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;
    RWSUIGBL.Key = '';
    return
elseif strcmp(RWSUIGBL.Key,'d')
    if isfield(Struct.(Func),'defloc')
        curloc = Struct.(Func).defloc;
    end    
else
    RWSUIGBL.Key = '';
    return
end
RWSUIGBL.Key = '';

%------------------------------------------
% Select File
%------------------------------------------
if curloc == 0
    curloc = [];
end
[file,path] = uigetfile(INPUT.Extension,'Select File',curloc);
if path == 0
    err.flag = 4;
    err.msg = 'File Not Selected';
    return
end

%------------------------------------------
% Create Label
%------------------------------------------
if isfield(INPUT,'DropExt')
    DropExt = INPUT.DropExt;
else
    DropExt = 'No';
end
[label] = TruncFileNameForDisp_v1([path,file],DropExt);

%------------------------------------------
% Save For Panel
%------------------------------------------
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.filename = strtok(file,'.');
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedfile = [path,file];
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedpath = path;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(INPUT.CurFunc).curloc = path;
if strcmp(INPUT.AssignPath,'Yes')
    SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;
end

%------------------------------------------
% Record Info
%------------------------------------------
saveData.file = file;
saveData.path = path;
saveData.loc = [path,file];
saveData.label = label;

funclabel = SCRPTGBL.RWSUI.funclabel;
callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
if isempty(callingfuncs)
    SCRPTGBL.([funclabel,'_Data']) = saveData;
elseif length(callingfuncs) == 1
    SCRPTGBL.([callingfuncs{1},'_Data']).([funclabel,'_Data']) = saveData;
elseif length(callingfuncs) == 2
    SCRPTGBL.([callingfuncs{1},'_Data']).([callingfuncs{2},'_Data']).([funclabel,'_Data']) = saveData;
end



