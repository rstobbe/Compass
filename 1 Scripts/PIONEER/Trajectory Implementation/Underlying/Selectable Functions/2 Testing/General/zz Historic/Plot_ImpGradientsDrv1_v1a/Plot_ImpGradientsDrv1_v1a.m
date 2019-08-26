%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_ImpGradientsDrv1_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Ortho Gradients');
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
    err.msg = 'No Implementation in Global Memory';
    return  
end
IMP = TOTALGBL{2,val};

%-----------------------------------------------------
% Test
%-----------------------------------------------------
if not(isfield(IMP,'Kmat'))
    err.flag = 1;
    err.msg = 'Global is not from implementation';
    return
end

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
PLOT.method = SCRPTGBL.CurrentTree.Func;
PLOT.trajnum = str2double(SCRPTGBL.CurrentTree.('TrajNum'));

%---------------------------------------------
% Plot Trajectory
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.PLOT = PLOT;
INPUT.IMP = IMP;
[OUTPUT,err] = func(INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';
