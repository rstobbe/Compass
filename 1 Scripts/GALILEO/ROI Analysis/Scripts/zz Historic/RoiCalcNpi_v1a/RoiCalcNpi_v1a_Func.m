%=========================================================
% 
%=========================================================

function [CALCTOP,err] = RoiCalcNpi_v1a_Func(CALCTOP,INPUT)

Status('busy','Calculate Noise Precicison Interval (NPI) in ROI');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
CALC = INPUT.CALC;
ROIS = INPUT.ROIS;
clear INPUT

%---------------------------------------------
% Calculate Precision
%---------------------------------------------
func = str2func([CALCTOP.calcprecfunc,'_Func']);  

for n = 1:length(ROIS)
    INPUT.ROI = ROIS(n).mask;
    [CALC,err] = func(CALC,INPUT);
    if err.flag
        return
    end
end
clear INPUT;

CALCTOP.CALC = CALC;


%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'CV',PRCALC.CV,'Output'};
Panel(2,:) = {'Nsiv',PRCALC.Nsiv,'Output'};
Panel(3,:) = {'SDVaveNoise',PRCALC.SDVaveNoise,'Output'};
Panel(4,:) = {'AbsPrec95',PRCALC.AbsPrec95,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
PRCALC.PanelOutput = PanelOutput;


Status2('done','',2);
Status2('done','',3);
