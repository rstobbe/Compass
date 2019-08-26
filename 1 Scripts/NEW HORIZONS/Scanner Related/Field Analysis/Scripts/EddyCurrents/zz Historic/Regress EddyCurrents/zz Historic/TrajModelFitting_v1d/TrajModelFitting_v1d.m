%==============================================
% (v1d)
%       - add trajectory / ortho selection
%==============================================

function [SCRPTipt,SCRPTGBL,err] = TrajModelFitting_v1d(SCRPTipt,SCRPTGBL)

Status('busy','Trajectory Model Fitting');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

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
            SCRPTGBL.('Imp_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Data_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Data_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Data_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Data_File';
            ErrDisp(err);
            return
        else
            SCRPTGBL.('Data_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Data_File';
        ErrDisp(err);
        return
    end
end


%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
RGRS.method = SCRPTGBL.CurrentTree.Func;
RGRS.modelfunc = SCRPTGBL.CurrentTree.('Modelfunc').Func;
RGRS.trajnum = str2double(SCRPTGBL.CurrentTree.('TrajNum'));
RGRS.trajortho = str2double(SCRPTGBL.CurrentTree.('TrajOrtho'));
RGRS.gstartshift = str2double(SCRPTGBL.CurrentTree.('GStartShift'));
IMP = SCRPTGBL.('Imp_File_Data').IMP;
EDDY = SCRPTGBL.('Data_File_Data').EDDY;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
ECMipt = SCRPTGBL.CurrentTree.('Modelfunc');
if isfield(SCRPTGBL,('Modelfunc_Data'))
    ECMipt.Modelfunc_Data = SCRPTGBL.Modelfunc_Data;
end

%------------------------------------------
% Model Function Info
%------------------------------------------
func = str2func(RGRS.modelfunc);           
[SCRPTipt,ECM,err] = func(SCRPTipt,ECMipt);
if err.flag
    return
end

%-----------------------------------------------------
% Perform Regression
%-----------------------------------------------------
func = str2func([RGRS.method,'_Func']);
INPUT.EDDY = EDDY;
RGRS.ECM = ECM;
INPUT.IMP = IMP;
[RGRS,err] = func(RGRS,INPUT);
if err.flag
    return
end

%-----------------------------------------------------
% Panel
%-----------------------------------------------------
SCRPTGBL.RWSUI.LocalOutput = RGRS.PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Eddy Current Regression:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Rgrs_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {RGRS};
SCRPTGBL.RWSUI.SaveVariableNames = {'RGRS'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};

