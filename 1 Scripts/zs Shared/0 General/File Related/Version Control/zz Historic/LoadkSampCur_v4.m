%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadkSampCur_v4(SCRPTipt,SCRPTGBL)

error;              % old - update call

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
    Func = SCRPTGBL.CurrentScript.Func;
    Struct = SCRPTGBL.CurrentScript.Struct;
    curloc = SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc;
else
    Func = SCRPTGBL.CurrentScript.Func;
    Struct = SCRPTGBL.CurrentScript.Struct;
    curloc = Struct.(Func).curloc;
end
RWSUIGBL.Key = '';

Status('busy','Select Mat File');
[file,path] = uigetfile('KSMP*.mat','Select k-Space Sampling File',curloc);
if path == 0
    err.flag = 4;
    err.msg = 'k-Space Sampling File Not Selected';
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
            break
        end
    end
end

SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedfile = loc;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(Func).curloc = path;
SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;

load(loc);
whos
if not(exist('saveData','var'));
    err.flag = 1;
    err.msg = 'File Does Not Contain ''saveData'' Variable';
    return
end
saveData.path = path;

funclabel = SCRPTGBL.RWSUI.funclabel;
callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
if isempty(callingfuncs)
    SCRPTGBL.([funclabel,'_Data']) = saveData;
elseif length(callingfuncs) == 1
    SCRPTGBL.([callingfuncs{1},'_Data']).([funclabel,'_Data']) = saveData;
elseif length(callingfuncs) == 2
    SCRPTGBL.([callingfuncs{1},'_Data']).([callingfuncs{2},'_Data']).([funclabel,'_Data']) = saveData;
end

Status('done','kSpace Sampling File Loaded');


