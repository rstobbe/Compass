%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectScriptDefaultCur_v5(SCRPTipt,SCRPTGBL)

global SCRPTPATHS
global RWSUIGBL
global FIGOBJS

err.flag = 0;
err.msg = '';

tab = SCRPTGBL.RWSUI.tab;
panelnum = SCRPTGBL.RWSUI.panelnum;
scrptnum = SCRPTGBL.RWSUI.scrptnum;
funclabel = SCRPTGBL.RWSUI.funclabel;

%------------------------------------------
% Test
%------------------------------------------
if panelnum ~= 5
    err.flag = 1;
    err.msg = 'Run script control from Panel-5';
    return
end

%------------------------------------------
% Determine Load Location
%------------------------------------------
Struct = SCRPTGBL.CurrentScript.Struct;
Func = SCRPTGBL.CurrentScript.Func;
if isempty(RWSUIGBL.Key)
    curloc = Struct.(Func).curloc;
elseif strcmp(RWSUIGBL.Key,'shift')
    curloc = SCRPTPATHS.(tab)(panelnum).outloc;
else
    curloc = Struct.(Func).curloc;
end
RWSUIGBL.Key = '';

%------------------------------------------
% Select Script File
%------------------------------------------
Status('busy','Select Script File');
[file,path] = uigetfile('*.mat','Select Script File',curloc);
if path == 0
    err.flag = 4;
    err.msg = 'Script File Not Selected';
    return
end
SCRPTPATHS.(tab)(panelnum).outloc = path;

%------------------------------------------
% Determine if Composite Script
%------------------------------------------
load([path,file]);
if exist('ScrptCellArray','var');
    panelnum = 1;
    [runfunc,CellArray,err] = LoadScrptDefault(panelnum,tab,scrptnum,file,path);
    if err.flag
        return
    end
elseif exist('CompCellArray','var');    
    for n = 1:4
        if not(isempty(CompCellArray{n,1,2}{1}))
            [runfunc,CellArray,err] = LoadScrptDefault2Panels(n,tab,scrptnum,CompCellArray(n,:,:));
            if err.flag
                ErrDisp(err);
                return
            end
        end
    end
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
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.ScrptCellArray = CellArray;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(Func).curloc = path;

%------------------------------------
% Save Panel Global
%-----------------------------------
saveData.path = path;
saveData.loc = [path,file];
saveData.label = label;
saveData.ScrptCellArray = CellArray;

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

