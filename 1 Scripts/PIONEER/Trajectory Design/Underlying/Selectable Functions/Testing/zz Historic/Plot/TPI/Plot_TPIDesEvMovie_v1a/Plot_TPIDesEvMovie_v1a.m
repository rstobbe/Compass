%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_TPIDesGradients_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot TPI Design Gradients (Ortho)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get EDDY Currents
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No Trajectory Design in Global Memory';
    return  
end
DES = TOTALGBL{2,val};

%-----------------------------------------------------
% Test
%-----------------------------------------------------
%if not(isfield(DES,'KSA'))
%    err.flag = 1;
%    err.msg = 'Global does Trajectory Design';
%    return
%end

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
PLOT.method = SCRPTGBL.CurrentTree.Func;
PLOT.gamma = str2double(SCRPTGBL.CurrentTree.('Gamma'));

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
set(findobj('tag','TestBox'),'string',DES.ExpDisp);

%---------------------------------------------
% Plot
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.DES = DES;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';