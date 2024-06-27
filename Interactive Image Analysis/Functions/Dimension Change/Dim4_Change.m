%===================================================
%
%===================================================
function Dim4_Change(AX,tab,axnum0,val)

global IMAGEANLZ

%----------------------------------------
% Change Dim
%----------------------------------------
IMAGEANLZ.(tab)(axnum0).SetDim4(val);

%----------------------------------------
% Update Image
%----------------------------------------
if IMAGEANLZ.(tab)(axnum0).DIMSTIE == 1
    start = 1;    
    stop = IMAGEANLZ.(tab)(axnum0).axeslen;
else
    start = axnum0;
    stop = axnum0;
end
for axnum = start:stop
    if IMAGEANLZ.(tab)(axnum).TestAxisActive
        IMAGEANLZ.(tab)(axnum).SetDim4(IMAGEANLZ.(tab)(axnum0).DIM4); 
        IMAGEANLZ.(tab)(axnum).SetImage;
        IMAGEANLZ.(tab)(axnum).SetImageSlice;
        IMAGEANLZ.(tab)(axnum).PlotImage;
        if IMAGEANLZ.(tab)(axnum).contrasthold == 0
            MaxVal = max(IMAGEANLZ.(tab)(axnum).imvol(:));
            maxcmax = IMAGEANLZ.(tab)(axnum).MaxCMaxValTest(num2str(MaxVal));
            if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
                IMAGEANLZ.(tab)(axnum).MaxContrastMaxUpdate(maxcmax); 
                IMAGEANLZ.(tab)(axnum).ChangeMaxContrastVal(MaxVal);
                IMAGEANLZ.(tab)(axnum).UpdateMaxContrastSlider;    
            elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
                for n = 1:3
                    IMAGEANLZ.(tab)(n).MaxContrastMaxUpdate(maxcmax);
                    IMAGEANLZ.(tab)(n).ChangeMaxContrastVal(str2double(src.String));
                end
                IMAGEANLZ.(tab)(axnum).UpdateMaxContrastSlider; 
            end
        end
    end
end

%----------------------------------------
% Current Point Related
%----------------------------------------
pt = AX.CurrentPoint;
x = pt(1,1);
y = pt(1,2);
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    CurrentPointUpdate(tab,axnum0,x,y);
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    CurrentPointUpdateOrtho(tab,axnum0,x,y);
end

%----------------------------------------
% ROI Related
%----------------------------------------
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    axeslen = IMAGEANLZ.(tab)(axnum0).axeslen;
    for axnum = 1:axeslen
        if IMAGEANLZ.(tab)(axnum).TestAxisActive
            if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
                if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                    IMAGEANLZ.(tab)(axnum).DrawSavedROIsNoPick([]);
                else
                    IMAGEANLZ.(tab)(axnum).DrawSavedROIs([]);
                end
                IMAGEANLZ.(tab)(axnum).ComputeAllSavedROIs;
                IMAGEANLZ.(tab)(axnum).SetSavedROIValues;
            end
            if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                IMAGEANLZ.(tab)(axnum).DrawCurrentROI([]);
                IMAGEANLZ.(tab)(axnum).DrawTempROI([],[]);
                IMAGEANLZ.(tab)(axnum).ComputeCurrentROI;
                IMAGEANLZ.(tab)(axnum).SetCurrentROIValue;
            end
        end
    end
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for axnum = 1:3
        if IMAGEANLZ.(tab)(axnum).TestAxisActive
            if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
                if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                    IMAGEANLZ.(tab)(axnum).DrawSavedROIsNoPick([]);
                else
                    IMAGEANLZ.(tab)(axnum).DrawSavedROIs([]);
                end
                if axnum == 1
                    IMAGEANLZ.(tab)(axnum).ComputeAllSavedROIs;
                    IMAGEANLZ.(tab)(axnum).SetSavedROIValues;
                end
            end
            if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                IMAGEANLZ.(tab)(axnum).DrawCurrentROI([]);
                IMAGEANLZ.(tab)(axnum).DrawTempROI([],[]);
                if axnum == 1
                    IMAGEANLZ.(tab)(axnum).ComputeCurrentROI;
                    IMAGEANLZ.(tab)(axnum).SetCurrentROIValue;
                end
            end
        end
    end
end
    
%----------------------------------------
% OrthoPresentation 
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).showortholine
    DrawOrthoLines(tab);
end
