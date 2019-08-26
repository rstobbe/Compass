%=========================================================
% (v1d)
%       - add 'type option
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_GriddedSlices_v1d(SCRPTipt,SCRPTGBL)

Status('busy','Plot Gridded Slices');
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
PLOT.script = SCRPTGBL.CurrentTree.Func;
PLOT.slice_no = SCRPTGBL.CurrentTree.Slice;
PLOT.type = SCRPTGBL.CurrentTree.Type;
PLOT.orientation = SCRPTGBL.CurrentTree.Orientation;
PLOT.minval = str2double(SCRPTGBL.CurrentTree.MinVal);
PLOT.maxval = str2double(SCRPTGBL.CurrentTree.MaxVal);
PLOT.colour = SCRPTGBL.CurrentTree.Colour;
PLOT.figno = SCRPTGBL.CurrentTree.FigNo;

%---------------------------------------------
% Plot
%---------------------------------------------
func = str2func([PLOT.script,'_Func']);
INPUT.PLOT = PLOT;
INPUT.GRD = GRD;
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