%=========================================================
% (v1a)
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_ImpRadSampTim_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Radial Sampling Timing');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Image
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No Image in Global Memory';
    return  
end
IMP = TOTALGBL{2,val};

%---------------------------------------------
% Get Input
%---------------------------------------------
PLOT.method = SCRPTGBL.CurrentTree.Func;

%---------------------------------------------
% Plot
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.PLOT = PLOT;
INPUT.IMP = IMP;
[OUTPUT,err] = func(INPUT);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';

Status('done','');
Status2('done','',2);
Status2('done','',3);


