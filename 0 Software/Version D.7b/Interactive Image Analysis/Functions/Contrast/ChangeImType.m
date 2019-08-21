%===================================================
% 
%===================================================
function ChangeImType(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

%--------------------------------------------
% Change Image Type
%--------------------------------------------
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    IMAGEANLZ.(tab)(axnum).ChangeImType(src.String{src.Value});
    IMAGEANLZ.(tab)(axnum).SetImageSlice;
    IMAGEANLZ.(tab)(axnum).PlotImage;
    IMAGEANLZ.(tab)(axnum).SetContrast;
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for r = 1:3
        IMAGEANLZ.(tab)(r).ChangeImType(src.String{src.Value});
        IMAGEANLZ.(tab)(r).SetImageSlice;
        IMAGEANLZ.(tab)(r).PlotImage;
        IMAGEANLZ.(tab)(r).SetContrast;
    end
end

%-----------------------------------
% Plot
%-----------------------------------
IMAGEANLZ.(tab)(axnum).PlotImage;
if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
    IMAGEANLZ.(tab)(axnum).DrawSavedROIs([]);
    IMAGEANLZ.(tab)(axnum).ComputeAllSavedROIs;
    IMAGEANLZ.(tab)(axnum).SetSavedROIValues;
end
if IMAGEANLZ.(tab)(axnum).GETROIS == 1
    IMAGEANLZ.(tab)(axnum).DrawCurrentROI([]);
    IMAGEANLZ.(tab)(axnum).ComputeCurrentROI;
    IMAGEANLZ.(tab)(axnum).SetCurrentROIValue;
end

%----------------------------------------
% OrthoPresentation 
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).showortholine
    DrawOrthoLines(tab);
end

