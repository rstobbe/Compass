%===================================================
%
%===================================================
function ShadeROIChange(src,event)

global IMAGEANLZ

currentax = gca;
tab = src.Parent.Parent.Parent.Tag;
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

switch IMAGEANLZ.(tab)(axnum).presentation 
    case 'Standard'
        IMAGEANLZ.(tab)(axnum).ShadeROIChange(src.Value);
        if IMAGEANLZ.(tab)(axnum).GETROIS == 1
            if src.Value == 1
                IMAGEANLZ.(tab)(axnum).CURRENTROI.CreateBaseROIMask;
            end
        end
        if IMAGEANLZ.(tab)(axnum).TestAxisActive
            Slice_Change(currentax,tab,axnum,0);
        end
        if src.Value == 1
            IMAGEANLZ.(tab)(axnum).TestUpdateCurrentROIValue;
        end
    case 'Ortho'
        for axnum = 1:3
            IMAGEANLZ.(tab)(axnum).ShadeROIChange(src.Value);
            if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                if src.Value == 1
                    IMAGEANLZ.(tab)(axnum).CURRENTROI.CreateBaseROIMask;
                end
            end
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
        if src.Value == 1
            IMAGEANLZ.(tab)(1).TestUpdateCurrentROIValue;
        end
end

%----------------------------------------
% OrthoPresentation 
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).showortholine
    DrawOrthoLines(tab);
end




