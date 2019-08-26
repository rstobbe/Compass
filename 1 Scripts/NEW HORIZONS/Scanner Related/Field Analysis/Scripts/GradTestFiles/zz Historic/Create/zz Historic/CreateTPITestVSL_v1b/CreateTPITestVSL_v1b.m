%=====================================================
% (v1b) 
%       - Save data for each dimension        
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateTPITestVSL_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Get Info');
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
if not(isfield(SCRPTGBL,'ProjImpX_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('ProjImpX_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('ProjImpX_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load ProjImpX_File';
            ErrDisp(err);
            return
        else
            load(file);
            SCRPTGBL.('ProjImpX_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load ProjImpX_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SCRPTGBL,'ProjImpY_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('ProjImpY_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('ProjImpY_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load ProjImpY_File';
            ErrDisp(err);
            return
        else
            load(file);
            SCRPTGBL.('ProjImpY_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load ProjImpY_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SCRPTGBL,'ProjImpZ_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('ProjImpZ_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('ProjImpZ_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load ProjImpZ_File';
            ErrDisp(err);
            return
        else
            load(file);
            SCRPTGBL.('ProjImpZ_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load ProjImpZ_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
GRD.method = SCRPTGBL.CurrentTree.Func;
GRD.pregdur0 = str2double(SCRPTGBL.CurrentTree.('PreGDur'));
PROJIMPX = SCRPTGBL.('ProjImpX_File_Data').IMP;
PROJIMPY = SCRPTGBL.('ProjImpY_File_Data').IMP;
PROJIMPZ = SCRPTGBL.('ProjImpZ_File_Data').IMP;
GRD.usetrajnum = str2double(SCRPTGBL.CurrentTree.('UseTrajNum'));
GRD.usetrajdir = SCRPTGBL.CurrentTree.('UseTrajDir');
GRD.wrtgradfunc = SCRPTGBL.CurrentTree.('WrtGradfunc').Func; 
GRD.wrtparamfunc = SCRPTGBL.CurrentTree.('WrtParamfunc').Func; 

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

%------------------------------------------
% Get Write Gradient Function Info
%------------------------------------------
func = str2func(GRD.wrtgradfunc);           
[SCRPTipt,WRTG,err] = func(SCRPTipt,WRTGipt);
if err.flag
    return
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
INPUT.PROJIMPX = PROJIMPX;
INPUT.PROJIMPY = PROJIMPY;
INPUT.PROJIMPZ = PROJIMPZ;
INPUT.WRTG = WRTG;
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
SCRPTipt(strcmp('GradSet_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {GRD};
SCRPTGBL.RWSUI.SaveVariableNames = {'GRD'};

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;

SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};
