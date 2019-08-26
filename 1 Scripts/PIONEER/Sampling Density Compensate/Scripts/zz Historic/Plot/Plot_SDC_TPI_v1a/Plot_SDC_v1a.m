%==================================================
% (v1a)
%      
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_SDC_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot SDC');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get GLOBAL
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No Implementation in Global Memory';
    return  
end
SDC = TOTALGBL{2,val};

%-----------------------------------------------------
% Test
%-----------------------------------------------------
if not(isfield(SDC,'SDC'))
    err.flag = 1;
    err.msg = 'Global is not from SDC';
    return
end

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
PLOT.method = SCRPTGBL.CurrentTree.Func;
PLOT.xaxis = SCRPTGBL.CurrentTree.('xAxis');

%---------------------------------------------
% Plot SDC
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.SDC = SDC;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';
