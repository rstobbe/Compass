%===================================================
%
%===================================================
function LinesROIChange(src,event)

global IMAGEANLZ

currentax = gca;
tab = src.Parent.Parent.Parent.Tag;
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

switch IMAGEANLZ.(tab)(axnum).presentation 
    case 'Standard'
        IMAGEANLZ.(tab)(axnum).LinesROIChange(src.Value);
        if IMAGEANLZ.(tab)(axnum).TestAxisActive
            Slice_Change(currentax,tab,axnum,0);
        end
    case 'Ortho'
        for axnum = 1:3
            IMAGEANLZ.(tab)(axnum).LinesROIChange(src.Value);
            IMAGEANLZ.(tab)(axnum).PlotImage;
            if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
                if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                    IMAGEANLZ.(tab)(axnum).DrawSavedROIsNoPick([]);
                else
                    IMAGEANLZ.(tab)(axnum).DrawSavedROIs([]);
                end
            end
            if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                IMAGEANLZ.(tab)(axnum).DrawCurrentROI([]);
                IMAGEANLZ.(tab)(axnum).DrawTempROI([],[]);
            end
        end
end

%----------------------------------------
% OrthoPresentation 
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).showortholine
    DrawOrthoLines(tab);
end




