%=====================================================
% (v1b) 
%       - update ECC file input 
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = LocalECCFile_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Local Eddy-Current Compensation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
SCRPTipt(strcmp('GradSet_Name',{SCRPTipt.labelstr})).entrystr = '';

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
if not(isfield(SCRPTGBL,'ECC_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('ECC_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('ECC_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load ECC_File';
            ErrDisp(err);
            return
        else
            SCRPTGBL.('ECC_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load ECC_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
GECC.method = SCRPTGBL.CurrentTree.Func;
GRD = SCRPTGBL.('GradDes_File_Data').GRD;
LECC = SCRPTGBL.('ECC_File_Data').LECC;
GECC.wrtgradfunc = SCRPTGBL.CurrentTree.('WrtGradfunc').Func; 
GECC.wrtparamfunc = SCRPTGBL.CurrentTree.('WrtParamfunc').Func; 
GECC.atrfunc = SCRPTGBL.CurrentTree.('ATRfunc').Func; 

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
WRTGipt = SCRPTGBL.CurrentTree.('WrtGradfunc');
if isfield(SCRPTGBL,('WrtGradfunc_Data'))
    WRTGipt.WrtGradfunc_Data = SCRPTGBL.WrtGradfunc_Data;
end
WRTPipt = SCRPTGBL.CurrentTree.('WrtParamfunc');
if isfield(SCRPTGBL,('WrtParamfunc_Data'))
    WRTPipt.WrtParamfunc_Data = SCRPTGBL.WrtParamfunc_Data;
end
ATRipt = SCRPTGBL.CurrentTree.('ATRfunc');
if isfield(SCRPTGBL,('ATRfunc_Data'))
    ATRipt.ATRfunc_Data = SCRPTGBL.ATRfunc_Data;
end

%------------------------------------------
% Get Add Transient Response Info
%------------------------------------------
func = str2func(GECC.atrfunc);           
[SCRPTipt,ATR,err] = func(SCRPTipt,ATRipt);
if err.flag
    return
end

%------------------------------------------
% Get Write Gradient Function Info
%------------------------------------------
func = str2func(GECC.wrtgradfunc);           
[SCRPTipt,WRTG,err] = func(SCRPTipt,WRTGipt);
if err.flag
    return
end

%------------------------------------------
% Get Write Parameter Function Info
%------------------------------------------
func = str2func(GECC.wrtparamfunc);           
[SCRPTipt,WRTP,err] = func(SCRPTipt,WRTPipt);
if err.flag
    return
end

%---------------------------------------------
% Create Gradients
%---------------------------------------------
func = str2func([GECC.method,'_Func']);
INPUT.GECC = GECC;
INPUT.WRTG = WRTG;
INPUT.WRTP = WRTP;
INPUT.ATR = ATR;
INPUT.GRD = GRD;
INPUT.LECC = LECC;
[GECC,err] = func(GECC,INPUT);
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
SCRPTipt(strcmp('GradSet_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {GECC};
SCRPTGBL.RWSUI.SaveVariableNames = {'GECC'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};
