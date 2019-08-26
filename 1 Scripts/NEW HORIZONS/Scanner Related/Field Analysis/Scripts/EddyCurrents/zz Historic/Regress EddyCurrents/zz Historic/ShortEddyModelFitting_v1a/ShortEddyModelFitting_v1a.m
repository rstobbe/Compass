%==============================================
% (v1a)
%       - r
%==============================================

function [SCRPTipt,SCRPTGBL,err] = ShortEddyModelFitting_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Get Eddy Current Regression Info');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'GradDes_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('GradDes_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('GradDes_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GradDes_File';
            ErrDisp(err);
            return
        else
            SCRPTGBL.('GradDes_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GradDes_File';
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
RGRS.gstartshift = str2double(SCRPTGBL.CurrentTree.('GStartShift'));
RGRS.rgrsstart = str2double(SCRPTGBL.CurrentTree.('RgrsStart'));
GRD = SCRPTGBL.('GradDes_File_Data').GRD;
EDDY = SCRPTGBL.('Data_File_Data').EDDY;

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
set(findobj('tag','TestBox'),'string',EDDY.ExpDisp);

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
INPUT.GRD = GRD;
INPUT.EDDY = EDDY;
RGRS.ECM = ECM;
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

