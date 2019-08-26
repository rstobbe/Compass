%=========================================================
% (v1a) 
%     
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = PlotMontage_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Image Montage');
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
PLOT.slices = SCRPTGBL.CurrentScript.('Slices');
PLOT.insets = SCRPTGBL.CurrentScript.('Inset');
PLOT.nRows = str2double(SCRPTGBL.CurrentScript.('nRows'));
PLOT.imsize = SCRPTGBL.CurrentScript.('imSize');
PLOT.slclbl = SCRPTGBL.CurrentScript.('SliceLabel');
PLOT.figno = SCRPTGBL.CurrentScript.('FigNo');

%---------------------------------------------
% Plot
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

