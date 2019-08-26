%=========================================================
% (v4b)
%       - update to scrptgbl writing
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadConvKernCur_v4b(SCRPTipt,SCRPTGBL)

%error;              % old - update call

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
    curloc = SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc;
else
    Func = SCRPTGBL.CurrentScript.Func;
    Struct = SCRPTGBL.CurrentScript.Struct;
    curloc = Struct.(Func).curloc;
end
RWSUIGBL.Key = '';

Status('busy','Select Convolution Kernel');
[file,path] = uigetfile('*.mat','Select Convolution Kernel',curloc);
if path == 0
    err.flag = 4;
    err.msg = 'Convolution Kernel Not Selected';
    return
end
loc = [path,file];
ind = strfind(loc,filesep);
label = loc(ind(length(ind))+1:length(loc)-4);

SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedfile = loc;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(Func).curloc = path;
SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;

load(loc);
%whos
saveData.path = path;

funclabel = SCRPTGBL.RWSUI.funclabel;
callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
if isempty(callingfuncs)
    SCRPTGBL.([funclabel,'_Data']) = saveData;
elseif length(callingfuncs) == 1
    SCRPTGBL.([callingfuncs{1},'_Data']).([funclabel,'_Data']) = saveData;
elseif length(callingfuncs) == 2
    SCRPTGBL.([callingfuncs{1},'_Data']).([callingfuncs{2},'_Data']).([funclabel,'_Data']) = saveData;
elseif length(callingfuncs) == 3
    SCRPTGBL.([callingfuncs{1},'_Data']).([callingfuncs{2},'_Data']).([callingfuncs{3},'_Data']).([funclabel,'_Data']) = saveData;
end

Status('done','Convolution Kernel Loaded');


