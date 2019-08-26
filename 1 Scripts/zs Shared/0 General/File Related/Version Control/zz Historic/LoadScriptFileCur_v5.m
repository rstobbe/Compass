%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadScriptFileCur_v5(SCRPTipt,SCRPTGBL)


error;              % Should be calling 'SelectGeneralFileCur_v5

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
% Select Script File
%------------------------------------------
Status('busy','Select Script Output File');
[file,path] = uigetfile('*.mat','Select Script File',curloc);
if path == 0
    err.flag = 4;
    err.msg = 'Script Output File Not Selected';
    return
end

%------------------------------------------
% Create Label
%------------------------------------------
DropExt = 'Yes';
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
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(Func).curloc = path;
SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;

%------------------------------------
% Load
%-----------------------------------
load([path,file]);
if not(exist('saveData','var'));
    err.flag = 1;
    err.msg = 'Not an RWS Script Output File';
    return
end

%------------------------------------------
% Show Info
%------------------------------------------
%FIGOBJS.(tab).Info.String = saveData.;

%------------------------------------
% Save Panel Global
%-----------------------------------
saveData.path = path;
saveData.loc = [path,file];
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

Status('done','Script File Loaded');

