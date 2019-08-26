%=========================================================
% (v1a) 
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Calc_Mean_Kurt_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Calculate Mean Kurtosis');
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

%---------------------------------------------
% Load Input
%---------------------------------------------
KURT.script = SCRPTGBL.CurrentTree.Func;
KURT.loadmeth = SCRPTGBL.CurrentTree.Loadfunc.Func;
KURT.calcmeth = SCRPTGBL.CurrentTree.Calcfunc.Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('Loadfunc');
if isfield(SCRPTGBL,('Loadfunc_Data'))
    LOADipt.Loadfunc_Data = SCRPTGBL.Loadfunc_Data;
end

CALCipt = SCRPTGBL.CurrentTree.('Calcfunc');
if isfield(SCRPTGBL,('Calcfunc_Data'))
    CALCipt.Calcfunc_Data = SCRPTGBL.Calcfunc_Data;
end

%------------------------------------------
% Get Load Function Info
%------------------------------------------
func = str2func(KURT.loadmeth);           
[SCRPTipt,LOAD,err] = func(SCRPTipt,LOADipt);
if err.flag
    return
end

%------------------------------------------
% Get Calculate Function Info
%------------------------------------------
func = str2func(KURT.calcmeth);           
[SCRPTipt,CALC,err] = func(SCRPTipt,CALCipt);
if err.flag
    return
end

%---------------------------------------------
% Calculate Kurtosis
%---------------------------------------------
func = str2func([KURT.script,'_Func']);
INPUT.LOAD = LOAD;
INPUT.CALC = CALC;
[OUTPUT,err] = func(INPUT,KURT);
if err.flag
    return
end

%--------------------------------------------
% Saved Structure
%--------------------------------------------
MK = KURT;
MK.Im = OUTPUT.MK;
MK.CALC = OUTPUT.CALC;
MD = KURT;
MD.Im = OUTPUT.MD;
MD.CALC = OUTPUT.CALC;
CstrMat = KURT;
CstrMat.Im = OUTPUT.CstrMat;
CstrMat.CALC = OUTPUT.CALC;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Image:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
name = cell2mat(name);
SCRPTipt(strcmp('Image_Name',{SCRPTipt.labelstr})).entrystr = name;

SCRPTGBL.RWSUI.SaveVariables = {MK,MD,CstrMat};
SCRPTGBL.RWSUI.SaveVariableNames = {'MK','MD','CstrMat'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = {[name,'_MK'],[name,'_MD'],[name,'_CstrMat']};
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = {[name,'_MK'],[name,'_MD'],[name,'_CstrMat']};

Status('done','');
Status2('done','',2);
Status2('done','',3);
