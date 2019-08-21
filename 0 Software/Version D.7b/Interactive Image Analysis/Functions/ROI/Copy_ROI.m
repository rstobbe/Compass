%============================================
% Copy_ROIs
%============================================
function Copy_ROI(tab0,axnum0,roinum0,tab1,axnum1,roinum1)

global TOTALGBL
global IMAGEANLZ
global FIGOBJS

if strcmp(IMAGEANLZ.(tab0)(axnum0).MOVEFUNCTION,'buildroi')
    error;          % shouldn't get here
end
if strcmp(IMAGEANLZ.(tab1)(axnum1).MOVEFUNCTION,'buildroi')
    error;          % shouldn't get here
end

totgblnum0 = FIGOBJS.(tab0).ImAxes(axnum0).UserData.totgblnum;
ImSize0 = size(TOTALGBL{2,totgblnum0}.Im);
totgblnum1 = FIGOBJS.(tab1).ImAxes(axnum1).UserData.totgblnum;
ImSize1 = size(TOTALGBL{2,totgblnum1}.Im);

for n = 1:3
    if ImSize0(n) ~= ImSize1(n)
        Status2('error','Image Dimensions Incompatible',1);
        return
    end
end

IMAGEANLZ.(tab1)(axnum1).SAVEDXLOC{roinum1} = IMAGEANLZ.(tab0)(axnum0).SAVEDXLOC{roinum0};
IMAGEANLZ.(tab1)(axnum1).SAVEDYLOC{roinum1} = IMAGEANLZ.(tab0)(axnum0).SAVEDYLOC{roinum0};
IMAGEANLZ.(tab1)(axnum1).SAVEDZLOC{roinum1} = IMAGEANLZ.(tab0)(axnum0).SAVEDZLOC{roinum0};
IMAGEANLZ.(tab1)(axnum1).ROINAMES{roinum1} = IMAGEANLZ.(tab0)(axnum0).ROINAMES{roinum0};
IMAGEANLZ.(tab1)(axnum1).SAVEDROISFLAG = 1;    

ImagingPlot(tab1,axnum1,totgblnum1);
Draw_Saved_ROIs(tab1,axnum1);
if not(isempty(IMAGEANLZ.(tab1)(axnum1).XLOCARR{1}))
    Draw_Current_ROI(AvailAx(axnum1),tab1,axnum1,IMAGEANLZ.(tab1)(axnum1).XLOCARR,IMAGEANLZ.(tab1)(axnum1).YLOCARR,IMAGEANLZ.(tab1)(axnum1).ZLOCARR);
end
Compute_Select_Saved_ROIs(tab1,axnum1,roinum1);    

