%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_T2RlxDesNa_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot T2 Relaxometry Design');
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
RLXDES = TOTALGBL{2,val};

%-----------------------------------------------------
% Test
%-----------------------------------------------------
if not(isfield(RLXDES,'T2f'))
    err.flag = 1;
    err.msg = 'Global Na Relaxometry Design';
    return
end

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
PLOT.method = SCRPTGBL.CurrentTree.Func;
PLOT.PI = str2double(SCRPTGBL.CurrentTree.('PI'));

%---------------------------------------------
% Plot 
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.RLXDES = RLXDES;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';
