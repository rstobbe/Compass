%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadTrajImpCur_v4(SCRPTipt,SCRPTGBL)

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
% Load Traj_Imp
%------------------------------------------
Status('busy','Select Trajectory Implementation File');
[file,path] = uigetfile('IMP*.mat','Select Trajectory Implementation File',curloc);
if path == 0
    err.flag = 4;
    err.msg = 'Trajectory Implementation File Not Selected';
    return
end

%------------------------------------------
% Load
%------------------------------------------
load([path,file]);
if not(exist('saveData','var'));
    err.flag = 1;
    err.msg = 'Not an RWS Script Output File';
    return
end
if not(isfield(saveData,'IMP'))
    err.flag = 1;
    err.msg = 'Not an Trajectory Implementation File';
    return
end

%------------------------------------------
% Show Info
%------------------------------------------
FIGOBJS.(tab).Info.String = saveData.IMP.ExpDisp;

%------------------------------------------
% Update Name/Path
%------------------------------------------
saveData.IMP.name = file(1:end-4);
saveData.IMP.path = path;

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
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = saveData.IMP.ExpDisp;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(Func).curloc = path;
SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;

%------------------------------------------
% Save Panel Global
%------------------------------------------
saveData.path = path;
saveData.loc = [path,file];
saveData.label = label;

%------------------------------------------
% Return
%------------------------------------------
funclabel = SCRPTGBL.RWSUI.funclabel;
callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
if isempty(callingfuncs)
    SCRPTGBL.([funclabel,'_Data']) = saveData;
elseif length(callingfuncs) == 1
    SCRPTGBL.([callingfuncs{1},'_Data']).([funclabel,'_Data']) = saveData;
elseif length(callingfuncs) == 2
    SCRPTGBL.([callingfuncs{1},'_Data']).([callingfuncs{2},'_Data']).([funclabel,'_Data']) = saveData;
end

Status('done','Trajectory Implementation Loaded');


