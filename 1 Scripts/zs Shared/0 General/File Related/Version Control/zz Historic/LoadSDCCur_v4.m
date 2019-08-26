%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadSDCCur_v4(SCRPTipt,SCRPTGBL)

%error;          % old - update call

global SCRPTPATHS
global RWSUIGBL

tab = SCRPTGBL.RWSUI.tab;

err.flag = 0;
err.msg = '';

if isempty(RWSUIGBL.Key)
    Func = SCRPTGBL.CurrentScript.Func;
    Struct = SCRPTGBL.CurrentScript.Struct;
    curloc = Struct.(Func).curloc;
elseif strcmp(RWSUIGBL.Key,'shift')
    curloc = SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc;
else
    Func = SCRPTGBL.CurrentScript.Func;
    Struct = SCRPTGBL.CurrentScript.Struct;
    curloc = Struct.(Func).curloc;
end
RWSUIGBL.Key = '';
Func = SCRPTGBL.CurrentScript.Func;
Struct = SCRPTGBL.CurrentScript.Struct;
loadpanel = Struct.(Func).loadpanel;

Status('busy','Select SDC File');
[file,path] = uigetfile('SDC*.mat','Select SDC File',curloc);
if path == 0
    err.flag = 4;
    err.msg = 'SDC File Not Selected';
    return
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
            ditch = length(label) - RWSUIGBL.fullwid;
            label = ['...',label(ditch+5:length(label))];
            break
        end
    end
end

SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedfile = loc;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(Func).curloc = loc;
SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;

if strcmp(loadpanel,'Yes')
    panelnum = 3;
    panel = 'sdc';
    [saveData,err] = LoadSelectedFile_B9(panelnum,panel,path,file);
    if err.flag
        ErrDisp(err);
    end
    err.flag = 0;
    err.msg = '';
else
    load(loc);
end
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

Status('done','SDC Loaded');

