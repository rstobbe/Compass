%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ROIsliceevolve_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot ROI Slice Evolution');
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
% Get Input
%---------------------------------------------
PLOT.method = SCRPTGBL.CurrentScript.Func;

%---------------------------------------------
% Fit
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT = struct();
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.KeepEdit = 'yes';
