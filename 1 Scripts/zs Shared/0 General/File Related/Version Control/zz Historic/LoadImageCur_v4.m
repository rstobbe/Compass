%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadImageCur_v4(SCRPTipt,SCRPTGBL)

global SCRPTPATHS
global RWSUIGBL
global FIGOBJS

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

Status('busy','Select Mat File');
[file,path] = uigetfile('*.mat','Select Image File',curloc);
if path == 0
    err.flag = 4;
    err.msg = 'Image File Not Selected';
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
        test = length(label)
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

% load(loc);
% if not(exist('saveData','var'));
%     whos
%     err.flag = 1;
%     err.msg = 'File Does Not Contain ''saveData'' Variable';
%     return
% end
% 
% if isfield(saveData,'IMG')
%     if isfield(saveData.IMG,'ExpDisp')
%         FIGOBJS.(tab).Info.String = saveData.IMG.ExpDisp;
%     end
% end

%------------------------------------
% Update File Info
%------------------------------------
saveData.IMG.path = path;
saveData.IMG.name = file;

%------------------------------------
% Write to ListBox
%-----------------------------------
button = questdlg('Write Image to ListBox?');
if strcmp(button,'Yes')
    File2Global(saveData,saveGlobalNames,saveSCRPTcellarray,tab)
end

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

