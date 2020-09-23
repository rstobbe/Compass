%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectDirDef_v5(SCRPTipt,SCRPTGBL,INPUT)

global RWSUIGBL
global SCRPTPATHS

tab = SCRPTGBL.RWSUI.tab;
err.flag = 0;
err.msg = '';

%------------------------------------------
% Determine Load Location
%------------------------------------------
Struct = SCRPTGBL.CurrentScript.Struct;
Func = SCRPTGBL.CurrentScript.Func;
if isempty(RWSUIGBL.Key)
    defaultfunc = 'Load From';
    defloc = Struct.(Func).defloc;    
elseif strcmp(RWSUIGBL.Key,'control')
    defaultfunc = 'Make';
    defloc = Struct.(Func).defloc;
else
    defaultfunc = 'Load From';
    defloc = Struct.(Func).defloc;
end
RWSUIGBL.Key = '';

%------------------------------------------
% Go
%------------------------------------------
switch defaultfunc
    case 'Make'
        Status('busy','Select Folder to Make Default');
        path = uigetdir(defloc,'Select Folder to Make Default');
        if path == 0
            err.flag = 4;
            err.msg = 'Default Folder Not Selected';
            return
        end
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(Func).defloc = path;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(INPUT.CurFunc).curloc = path;
        Status('done','Default Directory Selected');
        return
                
     case 'Load From' 
        path = uigetdir(defloc,'Select Directory');
        if path == 0
            err.flag = 4;
            err.msg = 'Directory Not Selected';
            return
        end
        DropExt = 'No';
        [label] = TruncFileNameForDisp_v1(path,DropExt);

        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = label;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = label;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedpath = path;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(INPUT.CurFunc).curloc = path;
        SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;

        saveData.file = '';
        saveData.path = path;
        saveData.loc = path;
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
end

Status('done','Directory Selected');


