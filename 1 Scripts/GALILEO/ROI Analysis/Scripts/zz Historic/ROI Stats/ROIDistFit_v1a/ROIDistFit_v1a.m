%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ROIDistFit_v1a(SCRPTipt,SCRPTGBL)

Status('busy','ROI Distribution Fit');
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
FIT.method = SCRPTGBL.CurrentScript.Func;

%---------------------------------------------
% Fit
%---------------------------------------------
func = str2func([FIT.method,'_Func']);
INPUT = struct();
[FIT,err] = func(FIT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.KeepEdit = 'yes';

