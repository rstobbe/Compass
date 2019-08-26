%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadImageDef_v4(SCRPTipt,SCRPTGBL)

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
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.('LoadImageCur_v4').curloc = path;
        Status('done','Default Directory Selected');
        return

    case 'Load From File'        
        [file,path] = uigetfile('*.mat','Select Image File',defloc);
        if path == 0
            err.flag = 4;
            err.msg = 'Image File Not Selected';
            return
        end
        load([path,file]);
        %whos
        
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
        file = [saveData.IMG.name,'.mat'];
end
          
loc = [path,file];
label = loc;
if length(label) > RWSUIGBL.fullwid
    ind = strfind(loc,filesep);
    n = 1;
    loc1 = loc(1:length(loc)-4);
    while true
        label = ['...',loc1(ind(n):length(loc1))];
        if length(label) < RWSUIGBL.fullwid
            break
        end
        n = n+1;
        if n > length(ind)
            break
        end
    end
end

SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedfile = loc;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.('LoadImageCur_v4').curloc = path;
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
saveData.loc = loc;
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

Status('done','Image File Loaded');

