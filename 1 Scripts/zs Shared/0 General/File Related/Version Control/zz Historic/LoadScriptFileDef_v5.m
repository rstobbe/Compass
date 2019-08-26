%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadScriptFileDef_v5(SCRPTipt,SCRPTGBL)

global RWSUIGBL
global SCRPTPATHS
global TOTALGBL
global FIGOBJS

tab = SCRPTGBL.RWSUI.tab;

err.flag = 0;
err.msg = '';

if isempty(RWSUIGBL.Key)
    defaultfunc = 'Load From Global';
    Func = SCRPTGBL.CurrentScript.Func;
    Struct = SCRPTGBL.CurrentScript.Struct;
    defloc = Struct.(Func).defloc;    
elseif strcmp(RWSUIGBL.Key,'shift')
    defaultfunc = 'Load From File';
    Func = SCRPTGBL.CurrentScript.Func;
    Struct = SCRPTGBL.CurrentScript.Struct;
    defloc = Struct.(Func).defloc;   
elseif strcmp(RWSUIGBL.Key,'control')
    defaultfunc = 'Make';
    Func = SCRPTGBL.CurrentScript.Func;
    Struct = SCRPTGBL.CurrentScript.Struct;
    defloc = Struct.(Func).defloc;
else
    defaultfunc = 'Load From File';
    Func = SCRPTGBL.CurrentScript.Func;
    Struct = SCRPTGBL.CurrentScript.Struct;
    defloc = Struct.(Func).defloc;
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
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.('LoadScriptFileCur').curloc = path;
        Status('done','Default Directory Selected');
        return

    case 'Load From File'        
        load(loc);
        if not(exist('saveData','var'));
            err.flag = 1;
            err.msg = 'Not an RWS Script Output File';
            return
        end
        %FIGOBJS.(tab).Info.String = saveData.;
        %saveData.IMG = IMG;
        %saveData.IMG.path = path;
        %saveData.IMG.file = file;
        %button = questdlg('Write Image to ListBox?');
        %if strcmp(button,'Yes')
        %    totalgbl{1} = Name;
        %    totalgbl{2} = IMG;
        %    Load_TOTALGBL(totalgbl,tab)
        %end
      
    case 'Load From Global' 
        val = FIGOBJS.(tab).GblList.Value;
        if isempty(val)
            err.flag = 1;
            err.msg = 'No Global Selected';
            return
        end
        totgblnum = FIGOBJS.(tab).GblList.UserData(val).totgblnum;
        if isfield(TOTALGBL{2,totgblnum},'structname')
            structname = TOTALGBL{2,totgblnum}.structname;
        else
            structname = 'RWS';
        end
        saveData.(structname) = TOTALGBL{2,totgblnum};
        if isfield(saveData.(structname),'path')
            path = saveData.(structname).path;
        else
            path = '';
        end
        if isempty(strfind(saveData.(structname).name,'.'))
            file = [saveData.(structname).name,'.mat'];
        else
            file = saveData.(structname).name;
        end
end
          
%------------------------------------------
% Create Label
%------------------------------------------
DropExt = 'No';
[label] = TruncFileNameForDisp_v1([path,file],DropExt);

%------------------------------------------
% Save For Panel
%------------------------------------------
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedfile = [path,file];
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedpath = path;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedfilename = file;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.('LoadScriptFileCur').curloc = path;
SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;

%------------------------------------
% Update File Info
%------------------------------------
saveData.(structname).path = path;
saveData.(structname).name = file;

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

Status('done','Script File Loaded');

