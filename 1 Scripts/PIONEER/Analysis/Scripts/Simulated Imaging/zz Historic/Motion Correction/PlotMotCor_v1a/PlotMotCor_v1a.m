%=========================================================
% (v1a) 
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = PlotMotCor_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Image Montage');
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
MOTCOR = TOTALGBL{2,val};

%---------------------------------------------
% Get Input
%---------------------------------------------
PLOT.method = SCRPTGBL.CurrentScript.Func;

%---------------------------------------------
% Plot
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.PLOT = PLOT;
INPUT.MOTCOR = MOTCOR;
[OUTPUT,err] = func(INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'mo';

