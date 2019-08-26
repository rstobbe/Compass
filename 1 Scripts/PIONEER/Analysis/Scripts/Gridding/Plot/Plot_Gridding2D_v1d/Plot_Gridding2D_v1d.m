%=========================================================
% (v1d)
%       - add 'type option
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_Gridding2D_v1d(SCRPTipt,SCRPTGBL)

Status('busy','Plot Gridded Slices');
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
GRD = TOTALGBL{2,val};

%---------------------------------------------
% Get Input
%---------------------------------------------
PLOT.script = SCRPTGBL.CurrentTree.Func;
PLOT.type = SCRPTGBL.CurrentTree.Type;
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