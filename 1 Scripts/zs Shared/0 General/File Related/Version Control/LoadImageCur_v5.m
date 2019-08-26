%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadImageCur_v5(SCRPTipt,SCRPTGBL)

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
% Get File Type
%------------------------------------------
if isfield(Struct,'selectedfile')
    ext = Struct.selectedfile(end-2:end);
    if strcmp(ext,'hdr')
        filetype = 'Analyze';
    elseif strcmp(ext,'mat')
        filetype = 'Mat';
    elseif strcmp(ext,'nii')
        filetype = 'NIFTI';
    else
        filetype = 'Mat';
    end
else
    filetype = '';
end

%------------------------------------------
% Select Image
%------------------------------------------
[file,path,err] = Select_Image(curloc,filetype);
if err.flag
    return
end

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
% Show Info
%------------------------------------------
if strcmp(tab(1:2),'IM')
    FIGOBJS.(tab).InfoL.String = IMG.IMDISP.ImInfo.info;
else
    FIGOBJS.(tab).Info.String = IMG.IMDISP.ImInfo.info;
end

%------------------------------------------
% Save For Panel
%------------------------------------------
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = label;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;
if not(isfield(SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct,'display'))
    SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.display = IMG.ExpDisp;
end
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.filename = strtok(file,'.');
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedfile = [path,file];
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedpath = path;
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(Func).curloc = path;
SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;

%------------------------------------
% Update File Info
%------------------------------------
saveData.IMG = IMG;
saveData.IMG.path = path;
saveData.IMG.file = file;
saveData.IMG.filetype = filetype;

%------------------------------------
% Write to ListBox
%-----------------------------------
button = questdlg('Write Image to ListBox?');
if strcmp(button,'Yes')
    totalgbl{1} = Name;
    totalgbl{2} = IMG;
    from = 'ImageLoad';
    Load_TOTALGBL(totalgbl,tab,from);
end

%------------------------------------
% Save Panel Global
%-----------------------------------
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

Status('done','Image File Loaded');
Status2('done','',2);
Status2('done','',3);
