%=====================================================
% (v1b) 
%       - extension from CreateBPGradVSL_v1b    
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateMultiBPGradsVSL_v1b(SCRPTipt,SCRPTGBL)

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
% Get Input
%---------------------------------------------
GRD.method = SCRPTGBL.CurrentTree.Func;
GRD.pregdur0 = str2double(SCRPTGBL.CurrentTree.('PreGDur'));
GRD.gatmaxdur0 = str2double(SCRPTGBL.CurrentTree.('GatMaxDur'));
GRD.intergdur0 = str2double(SCRPTGBL.CurrentTree.('InterGDur'));
GRD.gstepdur = str2double(SCRPTGBL.CurrentTree.('GStepDur'));
GRD.gsl = str2double(SCRPTGBL.CurrentTree.('Gsl'));
GRD.gstart = str2double(SCRPTGBL.CurrentTree.('Gstart'));
GRD.gstep = str2double(SCRPTGBL.CurrentTree.('Gstep'));
GRD.gstop = str2double(SCRPTGBL.CurrentTree.('Gstop'));
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
