%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadImageFolderCur_v5(SCRPTipt,SCRPTGBL)

Status('busy','Load Image Folder');

global SCRPTPATHS
global RWSUIGBL
global FIGOBJS

RWSUI = SCRPTGBL.RWSUI;
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
% Select Image
%------------------------------------------
path = uigetdir(curloc,'Select Folder of Images');
if path == 0
    err.flag = 4;
    err.msg = 'Directory Not Selected';
    return
end
path = [path,'\'];
SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;

%------------------------------------------
% Get Total
%------------------------------------------
global MULTIFILELOAD
listing = dir(path);                                        % assume all are images for now
listing = listing(3:end);
MULTIFILELOAD.numfiles = length(listing);
PanelScriptUpdate_B9(RWSUI.curpanipt-1,RWSUI.tab,RWSUI.panelnum);
SCRPTipt = LabelGet(RWSUI.tab,RWSUI.panelnum);

DropExt = 'No';
[label] = TruncFileNameForDisp_v1(path,DropExt);
SCRPTipt(RWSUI.curpanipt).entrystr = label;
SCRPTipt(RWSUI.curpanipt).entrystruct.entrystr = label;
SCRPTipt(RWSUI.curpanipt).entrystruct.numfiles = MULTIFILELOAD.numfiles;

for n = 1:length(listing)
    
    Status2('busy',num2str(n),2);
    saveData = [];
    file = listing(n).name;
    %------------------------------------------
    % Import Image
    %------------------------------------------
    [IMG,Name,ImType,err] = Import_Image(path,file);
    if err.flag
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
    SCRPTipt(RWSUI.curpanipt+n).entrystr = label;
    SCRPTipt(RWSUI.curpanipt+n).entrystruct.entrystr = label;
    SCRPTipt(RWSUI.curpanipt+n).entrystruct.altval = 1;
    SCRPTipt(RWSUI.curpanipt+n).entrystruct.selectedfile = [path,file];
    SCRPTipt(RWSUI.curpanipt+n).entrystruct.(Func).curloc = path;

    %------------------------------------
    % Update File Info
    %------------------------------------
    saveData.IMG = IMG{1};
    saveData.IMG.path = path;
    saveData.IMG.file = file;

    %------------------------------------
    % Save Panel Global
    %-----------------------------------
    saveData.path = path;
    saveData.loc = [path,file];
    saveData.label = label;

    %------------------------------------------
    % Return
    %------------------------------------------
    callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
    if isempty(callingfuncs)
        SCRPTGBL.(['Image',num2str(n),'_Data']) = saveData;
    elseif length(callingfuncs) == 1
        SCRPTGBL.([callingfuncs{1},'_Data']).(['Image',num2str(n),'_Data']) = saveData;
    elseif length(callingfuncs) == 2
        SCRPTGBL.([callingfuncs{1},'_Data']).([callingfuncs{2},'_Data']).(['Image',num2str(n),'_Data']) = saveData;
    end
end

Status('done','');
Status2('done','',2);
