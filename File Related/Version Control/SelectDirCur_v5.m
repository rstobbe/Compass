%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectDirCur_v5(SCRPTipt,SCRPTGBL)

global SCRPTPATHS
global RWSUIGBL
global FIGOBJS

tab = SCRPTGBL.RWSUI.tab;
err.flag = 0;
err.msg = '';

%------------------------------------------
% Determine Load Location
%------------------------------------------
Struct = SCRPTGBL.CurrentScript.Struct;
Func = SCRPTGBL.CurrentScript.Func;
if isempty(RWSUIGBL.Key)
    curloc = Struct.(Func).curloc;
elseif strcmp(RWSUIGBL.Key,'shift')
    curloc = SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc;
else
    curloc = Struct.(Func).curloc;
end
RWSUIGBL.Key = '';

%------------------------------------------
% Select Directory
%------------------------------------------
path = uigetdir(curloc,'Select Directory');
if path == 0
    err.flag = 4;
    err.msg = 'Directory Not Selected';
    return
end

%------------------------------------------
% Create Label
%------------------------------------------
DropExt = 'No';
[label] = TruncFileNameForDisp_v1(path,DropExt);

%------------------------------------------
% Save For Panel
%------------------------------------------
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedpath = path;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(Func).curloc = path;
SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;

%------------------------------------
% Save Panel Global
%-----------------------------------
saveData.file = '';
saveData.path = path;
saveData.loc = path;
saveData.label = label;

%------------------------------------
% Return
%-----------------------------------
funclabel = SCRPTGBL.RWSUI.funclabel;
callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
if isempty(callingfuncs)
    SCRPTGBL.([funclabel,'_Data']) = saveData;
elseif length(callingfuncs) == 1
    SCRPTGBL.([callingfuncs{1},'_Data']).([funclabel,'_Data']) = saveData;
elseif length(callingfuncs) == 2
    SCRPTGBL.([callingfuncs{1},'_Data']).([callingfuncs{2},'_Data']).([funclabel,'_Data']) = saveData;
end

Status('done','Directory Selected');

