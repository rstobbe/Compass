%=========================================================
% 
%=========================================================

function [ROIANLZ,err] = ROI_Analysis_v1a_Func(ROIANLZ,INPUT)

Status('busy','ROI Analysis');
Status2('done','',2);
Status2('done','',3);

global SCRPTPATHS

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
CALC = INPUT.CALC;
ROIS = INPUT.ROIS;
IMAGEANLZ = INPUT.IMAGEANLZ;
tab = INPUT.tab;
clear INPUT

%---------------------------------------------
% Calculate ROI Parameters
%---------------------------------------------
func = str2func([ROIANLZ.analysisfunc,'_Func']);  
ROIANLZ.ExpDisp = char(13);
for n = 1:length(ROIS)
    INPUT.ROI = ROIS(n);
    RoiNames{n} = ROIS(n).roiname;
    INPUT.IMAGEANLZ = IMAGEANLZ;
    INPUT.OB = ROIS(n);
    [CALC,err] = func(CALC,INPUT);
    clear INPUT;
    if err.flag
        return
    end
    for m = 1:length(CALC.label)
        ROIANLZ.(CALC.label{m})(n) = CALC.return(m);
    end
    ROIANLZ.ExpDisp = [ROIANLZ.ExpDisp,char(13),CALC.ExpDisp];
    
    if isfield(CALC,'Figure')
        ROIANLZ.Figure(n) = CALC.Figure;
    end
end

roisloc = SCRPTPATHS.(tab)(1).roisloc;
if m > 0
    if m == 1
        T = table(ROIANLZ.(CALC.label{1}).','RowNames',RoiNames)
    elseif m == 2
        T = table(ROIANLZ.(CALC.label{1}).',ROIANLZ.(CALC.label{2}).','RowNames',RoiNames)
    elseif m == 3
        T = table(ROIANLZ.(CALC.label{1}).',ROIANLZ.(CALC.label{2}).',ROIANLZ.(CALC.label{3}).','RowNames',RoiNames,'VariableNames',{CALC.label{1},CALC.label{2},CALC.label{3}})
    end
    writetable(T,[roisloc,'TempExcel.xlsx'],'WriteRowNames',true);
end

ROIANLZ.saveable = CALC.saveable;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
