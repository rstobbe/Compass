%==================================================
% (v1b)
%       - Output Update
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_TFcross_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Plot TF');
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
    err.msg = 'No EDDY in Global Memory';
    return  
end
EDDY = TOTALGBL{2,val};

%-----------------------------------------------------
% Test
%-----------------------------------------------------
% if not(isfield(EDDY,'GeddyCross'))
%     err.flag = 1;
%     err.msg = 'Global does not contain cross eddy currents';
%     return
% end

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
PLOT.method = SCRPTGBL.CurrentTree.Func;
PLOT.clr = SCRPTGBL.CurrentTree.('Colour');
PLOT.cross = SCRPTGBL.CurrentTree.('Cross');

%---------------------------------------------
% Plot Eddy Currents
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.EDDY = EDDY;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';
