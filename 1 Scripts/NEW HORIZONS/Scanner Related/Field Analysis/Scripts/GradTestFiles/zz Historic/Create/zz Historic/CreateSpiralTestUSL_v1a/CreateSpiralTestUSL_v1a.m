%=====================================================
% (v1a) 
%           
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateSpiralTestUSL_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Get Info');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('GradTest_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam_B9(SCRPTipt,setfunc,SCRPTGBL.RWSUI.panel);

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Imp_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Imp_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Imp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Imp_File';
            ErrDisp(err);
            return
        else
            load(file);
            SCRPTGBL.('Imp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
end

if not(isfield(SCRPTGBL,'Grad_Folder_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Grad_Folder').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Grad_Folder').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Grad_Folder';
            ErrDisp(err);
            return
        else
            load(file);
            SCRPTGBL.('Grad_Folder_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Grad_Folder';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
GRD.method = SCRPTGBL.CurrentTree.Func;
IMP = SCRPTGBL.('Imp_File_Data').IMP;
GradFolder = SCRPTGBL.('Grad_Folder_Data').path;
GRD.usetrajnum = str2double(SCRPTGBL.CurrentTree.('UseTrajNum'));
GRD.usetrajdir = SCRPTGBL.CurrentTree.('UseTrajDir');
GRD.wrtparamfunc = SCRPTGBL.CurrentTree.('WrtParamfunc').Func; 

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
WRTPipt = SCRPTGBL.CurrentTree.('WrtParamfunc');
if isfield(SCRPTGBL,('WrtParamfunc_Data'))
    WRTPipt.WrtParamfunc_Data = SCRPTGBL.WrtParamfunc_Data;
end

%------------------------------------------
% Get Write Parameter Function Info
%------------------------------------------
func = str2func(GRD.wrtparamfunc);           
[SCRPTipt,WRTP,err] = func(SCRPTipt,WRTPipt);
if err.flag
    return
end

%---------------------------------------------
% Create Gradients
%---------------------------------------------
func = str2func([GRD.method,'_Func']);
INPUT.IMP = IMP;
INPUT.GradFolder = GradFolder;
INPUT.WRTP = WRTP;
[GRD,err] = func(GRD,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Gradient File:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('GradTest_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {GRD};
SCRPTGBL.RWSUI.SaveVariableNames = {'GRD'};

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;

SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};
