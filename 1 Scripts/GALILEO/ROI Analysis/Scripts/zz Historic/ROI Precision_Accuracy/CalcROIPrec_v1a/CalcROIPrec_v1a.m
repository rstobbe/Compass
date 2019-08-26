%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CalcROIPrec_v1a(SCRPTipt,SCRPTGBL)

global CURFIG

Status('busy','ROI Precision Calculation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Galileo Testing
%---------------------------------------------
[err] = RunScriptTest;
if err.flag
    return
end

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Analysis_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
CALCTOP.method = SCRPTGBL.CurrentScript.Func;
CALCTOP.calcprecfunc = SCRPTGBL.CurrentTree.('CalcPrecfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CALCipt = SCRPTGBL.CurrentTree.('CalcPrecfunc');
if isfield(SCRPTGBL,('CalcPrecfunc_Data'))
    CALCipt.CalcPrecfunc_Data = SCRPTGBL.CalcPrecfunc_Data;
end

%------------------------------------------
% Get Calc Function Info
%------------------------------------------
func = str2func(CALCTOP.calcprecfunc);           
[SCRPTipt,CALC,err] = func(SCRPTipt,CALCipt);
if err.flag
    return
end

%---------------------------------------------
% Fit
%---------------------------------------------
func = str2func([CALCTOP.method,'_Func']);
INPUT.CALC = CALC;
[CALCTOP,err] = func(CALCTOP,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
CALCTOP.ExpDisp = PanelStruct2Text(CALCTOP.CALC.PanelOutput);
set(findobj('tag',['Output',num2str(CURFIG)]),'string',CALCTOP.ExpDisp);

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Analysis:');
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
inds = strcmp('Analysis_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {CALCTOP};
SCRPTGBL.RWSUI.SaveVariableNames = {'CALCTOP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(name);

Status('done','');
Status2('done','',2);
Status2('done','',3);

