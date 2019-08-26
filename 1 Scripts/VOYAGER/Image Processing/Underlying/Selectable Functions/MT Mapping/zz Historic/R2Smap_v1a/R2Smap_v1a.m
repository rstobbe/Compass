%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = R2Smap_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Generate R2Star Map');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('R2Smap_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    if SCRPTGBL.RWSUI.scrptnum > indnum(1)
        indnum = indnum(2);
    else
        indnum = indnum(1);
    end
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Image_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Image_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Image_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Image_Files';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SCRPTGBL.('Image_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Image_Files';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
MAP.method = SCRPTGBL.CurrentScript.Func;
IMG = SCRPTGBL.('Image_File_Data').IMG;
MAP.MV = str2double(SCRPTGBL.CurrentScript.('RelMaskVal'));

%---------------------------------------------
% Create Map
%---------------------------------------------
func = str2func([MAP.method,'_Func']);
INPUT.IMG = IMG;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Map:');
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
SCRPTipt(indnum).entrystr = cell2mat(name);

IMG = MAP;
SCRPTGBL.RWSUI.SaveVariables = {IMG};
SCRPTGBL.RWSUI.SaveVariableNames = {'IMG'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(name);

Status('done','');
Status2('done','',2);
Status2('done','',3);

