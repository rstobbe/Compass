%============================================
%
%============================================
function LoadROIExternal(tab,axnum,ROI)

global IMAGEANLZ

imsize = IMAGEANLZ.(tab)(axnum).GetBaseImageSize([]);
if isempty(imsize)
    return
end

for n = 1:3
    if ROI.roiimsize(n) ~= imsize(n)
        Status2('error','ROI and Image Dimensions Incompatible',1);
        return
    end
end

if not(isempty(ROI.baseroiorient))
    if not(strcmp(ROI.baseroiorient,IMAGEANLZ.(tab)(axnum).GetBaseOrient([])))
        Status2('error','ROI and Image Orientations Incompatible',1);
        return
    end
end


roinum = IMAGEANLZ.(tab)(axnum).FindNextAvailableROI;

switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        if IMAGEANLZ.(tab)(axnum).ROITIE == 1
            start = 1;    
            stop = IMAGEANLZ.(tab)(axnum).axeslen;
        else
            start = axnum;
            stop = axnum;
        end
        for r = start:stop
            if IMAGEANLZ.(tab)(r).TestAxisActive
                IMAGEANLZ.(tab)(r).AddROI2Saved(ROI,roinum);
                IMAGEANLZ.(tab)(r).ActivateROI(roinum);
                IMAGEANLZ.(tab)(r).DrawSavedROIs([]);
                IMAGEANLZ.(tab)(r).ComputeSavedROI(roinum);
                IMAGEANLZ.(tab)(r).SetSavedROIValues;
            end
        end
        
    case 'Ortho'
        for r = 1:3
            IMAGEANLZ.(tab)(r).AddROI2Saved(ROI,roinum);
            IMAGEANLZ.(tab)(r).ActivateROI(roinum);
            IMAGEANLZ.(tab)(r).DrawSavedROIs([]);
        end
        IMAGEANLZ.(tab)(1).ComputeSavedROI(roinum);
        IMAGEANLZ.(tab)(1).SetSavedROIValues;           
end
