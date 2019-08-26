%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Match2Images_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Match 2 Images (FoV / Matrix)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Image_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam_B9(SCRPTipt,setfunc,SCRPTGBL.RWSUI.panel);

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
MATCH.method = SCRPTGBL.CurrentTree.Func;
MATCH.resizefunc = SCRPTGBL.CurrentTree.('Matchfunc').Func;
MATCH.dispfunc = SCRPTGBL.CurrentTree.('Dispfunc').Func;

%---------------------------------------------
% Load Image Data
%---------------------------------------------
if not(isfield(SCRPTGBL,'Image1_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Image1_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Image1_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Image1_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Loading Image');
            load(file);
            saveData.path = file;
            SCRPTGBL.('Image1_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Image1_File';
        return
    end
end
fields = fieldnames(SCRPTGBL.('Image1_File_Data'));
foundimage = 0;
for n = 1:length(fields)
    if isfield(SCRPTGBL.('Image1_File_Data').(fields{n}),'Im')
        IMG1 = SCRPTGBL.('Image1_File_Data').(fields{n});
        foundimage = 1;
        break
    end
end
if foundimage == 0;
    err.flag = 1;
    err.msg = 'Image1_File Selection Does Not Contain An Image';
    return
end

%---------------------------------------------
% Load B1map Data
%---------------------------------------------
if not(isfield(SCRPTGBL,'Image2_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Image2_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Image2_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Image2_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Loading Image');
            load(file);
            saveData.path = file;
            SCRPTGBL.('Image2_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Image2_File';
        return
    end
end
fields = fieldnames(SCRPTGBL.('Image2_File_Data'));
foundimage = 0;
for n = 1:length(fields)
    if isfield(SCRPTGBL.('Image2_File_Data').(fields{n}),'Im')
        IMG2 = SCRPTGBL.('Image2_File_Data').(fields{n});
        foundimage = 1;
        break
    end
end
if foundimage == 0;
    err.flag = 1;
    err.msg = 'Image2_File Selection Does Not Contain An Image';
    return
end

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
RSZipt = SCRPTGBL.CurrentTree.('Matchfunc');
if isfield(SCRPTGBL,('Matchfunc_Data'))
    RSZipt.Matchfunc_Data = SCRPTGBL.Matchfunc_Data;
end
DISPipt = SCRPTGBL.CurrentTree.('Dispfunc');
if isfield(SCRPTGBL,('Dispfunc_Data'))
    DISPipt.Dispfunc_Data = SCRPTGBL.Dispfunc_Data;
end

%------------------------------------------
% Get Mapping Function Info
%------------------------------------------
func = str2func(MATCH.resizefunc);           
[SCRPTipt,RSZ,err] = func(SCRPTipt,RSZipt);
if err.flag
    return
end

%------------------------------------------
% Get Display Function Info
%------------------------------------------
func = str2func(MATCH.dispfunc);           
[SCRPTipt,DISP,err] = func(SCRPTipt,DISPipt);
if err.flag
    return
end

%---------------------------------------------
% Match Images
%---------------------------------------------
func = str2func([MATCH.method,'_Func']);
INPUT.IMG1 = IMG1;
INPUT.IMG2 = IMG2;
INPUT.RSZ = RSZ;
INPUT.DISP = DISP;
[MATCH,err] = func(MATCH,INPUT);
if err.flag
    return
end
IMG = MATCH.IMG;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Image:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {IMG};
SCRPTGBL.RWSUI.SaveVariableNames = 'IMG';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);