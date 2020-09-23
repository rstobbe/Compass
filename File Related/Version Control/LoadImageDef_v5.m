%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadImageDef_v5(SCRPTipt,SCRPTGBL)

global RWSUIGBL
global SCRPTPATHS
global TOTALGBL
global FIGOBJS

tab = SCRPTGBL.RWSUI.tab;

err.flag = 0;
err.msg = '';

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
elseif strcmp(RWSUIGBL.Key,'control')
    defaultfunc = 'Make';
    defloc = Struct.(Func).defloc;
else
    defaultfunc = 'Load From File';
    curloc = Struct.(Func).defloc;
end
RWSUIGBL.Key = '';

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
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.('LoadImageCur').curloc = path;
        Status('done','Default Directory Selected');
        return

    case 'Load From File'        
        [file,path,err] = Select_Image(curloc,'*');
        if err.flag
            return
        end
        [IMG,Name,ImType,err] = Import_Image(path,file);
        if err.flag
            return
        end
        FIGOBJS.(tab).Info.String = IMG.IMDISP.ImInfo.info;
        saveData.IMG = IMG;
        saveData.IMG.path = path;
        saveData.IMG.file = file;
%         button = questdlg('Write Image to ListBox?');
%         if strcmp(button,'Yes')
%             totalgbl{1} = Name;
%             totalgbl{2} = IMG;
%             Load_TOTALGBL(totalgbl,tab)
%         end
        DropExt = 'Yes';
        
    case 'Load From Global' 
        val = FIGOBJS.(tab).GblList.Value;
        if isempty(val)
            err.flag = 1;
            err.msg = 'No Global Selected';
            return
        end
        totgblnum = FIGOBJS.(tab).GblList.UserData(val).totgblnum;
        saveData.IMG = TOTALGBL{2,totgblnum};
        if not(isfield(saveData.IMG,'Im'))
            err.flag = 1;
            err.msg = 'Global Does Not Contain Image';
            return
        end
        if isfield(saveData.IMG,'path')
            path = saveData.IMG.path;
        else
            path = '';
        end
        if isempty(strfind(saveData.IMG.name,'.'))
            file = [saveData.IMG.name,'.mat'];
        else
            file = saveData.IMG.name;
        end
        DropExt = 'No';        
end

if not(strcmp(defaultfunc,'Display'))
    %------------------------------------------
    % Create Label
    %------------------------------------------
    [label] = TruncFileNameForDisp_v1([path,file],DropExt);

    %------------------------------------------
    % Save For Panel
    %------------------------------------------
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = label;
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = label;
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;
    %if not(isfield(SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct,'display'))                      % comment for 'load from global'
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData.IMG.ExpDisp;
    %end
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedfile = [path,file];
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.('LoadImageCur').curloc = path;
    SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;

    %------------------------------------
    % Update File Info
    %------------------------------------
    saveData.IMG.path = path;
    saveData.IMG.name = file;

    %------------------------------------
    % Save Panel Global
    %-----------------------------------
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

Status('done','Image File Loaded');

