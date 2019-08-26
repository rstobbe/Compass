%=========================================================
% (v1b)
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_GriddedProfile_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Plot Gridded Profile');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Image
%---------------------------------------------
global TOTALGBL
global FIGOBJS
tab = SCRPTGBL.RWSUI.tab;
val = FIGOBJS.(tab).GblList.Value;
if isempty(val)
    err.flag = 1;
    err.msg = 'No Global Selected';
    return
end
totgblnum = FIGOBJS.(tab).GblList.UserData(val).totgblnum;
GRD = TOTALGBL{2,totgblnum};

%---------------------------------------------
% Get Input
%---------------------------------------------
PLOT.method = SCRPTGBL.CurrentTree.Func;

%---------------------------------------------
% Plot
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.GRD = GRD;
[PLOT,err] = func(INPUT,PLOT);
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