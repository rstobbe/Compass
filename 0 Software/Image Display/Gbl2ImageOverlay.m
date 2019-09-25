%====================================================
% 
%====================================================
function Gbl2ImageOverlay(tab,axnum,totgblnum)

global IMAGEANLZ

%----------------------------------------
% Test and Assign Data
%----------------------------------------
err = IMAGEANLZ.(tab)(axnum).TestForImage(totgblnum);
if err.flag
    ErrDisp(err)
    return
end
samedims = IMAGEANLZ.(tab)(axnum).ImageDimsCompare(totgblnum);
if samedims == 0
    abort = IMAGEANLZ.(tab)(axnum).RoiSizeTest(totgblnum);
    if abort == 1
        return
    end
end
IMAGEANLZ.(tab)(axnum).AssignOverlay(totgblnum);

%-----------------------------------
% Plot
%-----------------------------------
IMAGEANLZ.(tab)(axnum).SetImage;
IMAGEANLZ.(tab)(axnum).SetImageSlice;
IMAGEANLZ.(tab)(axnum).PlotImage;
if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
    IMAGEANLZ.(tab)(axnum).DrawSavedROIs([]);
end
if IMAGEANLZ.(tab)(axnum).GETROIS == 1
    IMAGEANLZ.(tab)(axnum).DrawCurrentROI([]);
end

%-----------------------------------
% Finish up
%-----------------------------------
axnum = 1;
IMAGEANLZ.(tab)(axnum).ShowImageInfo;
IMAGEANLZ.(tab)(axnum).UnHighlight;
IMAGEANLZ.(tab)(axnum).TurnOnDisplay;
IMAGEANLZ.(tab)(axnum).SetImageName;
IMAGEANLZ.(tab)(axnum).Move2Tab;
