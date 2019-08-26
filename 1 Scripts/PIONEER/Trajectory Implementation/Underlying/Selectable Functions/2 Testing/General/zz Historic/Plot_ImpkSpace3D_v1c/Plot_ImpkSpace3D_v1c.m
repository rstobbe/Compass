%==================================================
% (v1c)
%       - Input Handling Update
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_ImpkSpace3D_v1c(SCRPTipt,SCRPTGBL)

Status('busy','Plot 3D k-space');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Imp
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
IMP = TOTALGBL{2,totgblnum};

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
PLOT.trajnum = SCRPTGBL.CurrentTree.('TrajNum');
PLOT.relrad = str2double(SCRPTGBL.CurrentTree.('RelRad'));
PLOT.type = SCRPTGBL.CurrentTree.('Type');
PLOT.output = SCRPTGBL.CurrentTree.('Output');

%---------------------------------------------
% Plot
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.PLOT = PLOT;
INPUT.IMP = IMP;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';

Status('done','');
Status2('done','',2);
Status2('done','',3);

