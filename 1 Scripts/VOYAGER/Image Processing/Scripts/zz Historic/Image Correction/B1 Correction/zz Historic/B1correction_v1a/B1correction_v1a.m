%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = B1correction_v1a(SCRPTipt,SCRPTGBL)

Status('busy','B1 Correction');
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
B1CORR.method = SCRPTGBL.CurrentTree.Func;
B1CORR.corrfunc = SCRPTGBL.CurrentTree.('B1Corrfunc').Func;
B1CORR.dispfunc = SCRPTGBL.CurrentTree.('Dispfunc').Func;

%---------------------------------------------
% Load Image Data
%---------------------------------------------
if not(isfield(SCRPTGBL,'Image_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Image_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Image_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Image_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Loading Image');
            load(file);
            saveData.path = file;
            SCRPTGBL.('Image_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Image_File';
        return
    end
end
fields = fieldnames(SCRPTGBL.('Image_File_Data'));
foundimage = 0;
for n = 1:length(fields)
    if isfield(SCRPTGBL.('Image_File_Data').(fields{n}),'Im')
        IMG = SCRPTGBL.('Image_File_Data').(fields{n});
        foundimage = 1;
        break
    end
end
if foundimage == 0;
    err.flag = 1;
    err.msg = 'Image_File Selection Does Not Contain An Image';
    return
end

%---------------------------------------------
% Load B1map Data
%---------------------------------------------
if not(isfield(SCRPTGBL,'B1map_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('B1map_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('B1map_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load B1map_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Loading Image');
            load(file);
            saveData.path = file;
            SCRPTGBL.('B1map_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load B1map_File';
        return
    end
end
fields = fieldnames(SCRPTGBL.('B1map_File_Data'));
foundimage = 0;
for n = 1:length(fields)
    if isfield(SCRPTGBL.('B1map_File_Data').(fields{n}),'Im')
        B1MAP = SCRPTGBL.('B1map_File_Data').(fields{n});
        foundimage = 1;
        break
    end
end
if foundimage == 0;
    err.flag = 1;
    err.msg = 'B1map_File Selection Does Not Contain An Image';
    return
end

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CORFipt = SCRPTGBL.CurrentTree.('B1Corrfunc');
if isfield(SCRPTGBL,('B1Corrfunc_Data'))
    CORFipt.B1Corrfunc_Data = SCRPTGBL.B1Corrfunc_Data;
end
DISPipt = SCRPTGBL.CurrentTree.('Dispfunc');
if isfield(SCRPTGBL,('Dispfunc_Data'))
    DISPipt.Dispfunc_Data = SCRPTGBL.Dispfunc_Data;
end

%------------------------------------------
% Get Mapping Function Info
%------------------------------------------
func = str2func(B1CORR.corrfunc);           
[SCRPTipt,CORF,err] = func(SCRPTipt,CORFipt);
if err.flag
    return
end

%------------------------------------------
% Get Display Function Info
%------------------------------------------
func = str2func(B1CORR.dispfunc);           
[SCRPTipt,DISP,err] = func(SCRPTipt,DISPipt);
if err.flag
    return
end

%---------------------------------------------
% Correct Images
%---------------------------------------------
func = str2func([B1CORR.method,'_Func']);
INPUT.B1MAP = B1MAP;
INPUT.IMG = IMG;
INPUT.CORF = CORF;
INPUT.DISP = DISP;
[B1CORR,err] = func(B1CORR,INPUT);
if err.flag
    return
end
IMG = B1CORR.IMG;

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