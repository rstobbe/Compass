%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileDef_v5(SCRPTipt,SCRPTGBL,INPUT)

global RWSUIGBL
global SCRPTPATHS
global TOTALGBL
global FIGOBJS

tab = SCRPTGBL.RWSUI.tab;
err.flag = 0;
err.msg = '';
saveData = [];

Func = SCRPTGBL.CurrentScript.Func;
Struct = SCRPTGBL.CurrentScript.Struct;
if isempty(RWSUIGBL.Key)
    if isfield(SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct,'display')
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display;
        FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display;
    else
        FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = '';
    end
    defaultfunc = 'Display';
elseif strcmp(RWSUIGBL.Key,'shift')
    defaultfunc = 'Load From Global';
% elseif strcmp(RWSUIGBL.Key,'control')
%     defaultfunc = 'Make';
%     if isfield(Struct,Func)
%         defloc = Struct.(Func).defloc;
%     else
%         defloc = [];
%     end
else
    RWSUIGBL.Key = '';
    return
%     defaultfunc = 'Load From File';
%     curloc = Struct.(Func).defloc;
end
RWSUIGBL.Key = '';

%------------------------------------------
% Select File
%------------------------------------------
switch defaultfunc
%
%     case 'Make'
%         Status('busy','Select Folder to Make Default');
%         path = uigetdir(defloc,'Select Folder to Make Default');
%         if path == 0
%             err.flag = 4;
%             err.msg = 'Default Folder Not Selected';
%             return
%         end
%         SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(Func).defloc = path;
%         SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(INPUT.CurFunc).curloc = path;
%         Status('done','Default Directory Selected');
%         return
% 
%     case 'Load From File'        
%         if curloc == 0
%             curloc = [];
%         end
%         [file,path] = uigetfile(INPUT.Search,'Select File',curloc);
%         if path == 0
%             err.flag = 4;
%             err.msg = 'File Not Selected';
%             return
%         end
        
    case 'Load From Global' 
        val = FIGOBJS.(tab).GblList.Value;
        if isempty(val)
            err.flag = 1;
            err.msg = 'No Global Selected';
            return
        end
        totgblnum = FIGOBJS.(tab).GblList.UserData(val).totgblnum;
%         if ~contains(TOTALGBL{2,totgblnum}.name,INPUT.Assign)
%             err.flag = 1;
%             err.msg = 'Wrong kind of file';
%             return
%         end
        if strcmp(INPUT.Assign,'SDC')
            INPUT.Assign = 'SDCS';
        end
        if isempty(INPUT.Assign)
            if isfield(TOTALGBL{2,totgblnum},'structname')
                INPUT.Assign = TOTALGBL{2,totgblnum}.structname;
            else
                INPUT.Assign = 'SCRPT';
            end
        end
        saveData.(INPUT.Assign) = TOTALGBL{2,totgblnum};
        saveData.structname = INPUT.Assign;
        file = saveData.(INPUT.Assign).name;
        path = saveData.(INPUT.Assign).path;
end

if not(strcmp(defaultfunc,'Display'))
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
end
