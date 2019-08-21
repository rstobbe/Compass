%===================================================
% Slice_Change
%===================================================
function Slice_Change(AX,tab,axnum0,val)

global IMAGEANLZ
   
%----------------------------------------
% Change Slice
%----------------------------------------
sz = IMAGEANLZ.(tab)(axnum0).GetImageSize;
maxslc = sz(3);
slice = IMAGEANLZ.(tab)(axnum0).SLICE - val;
if slice > maxslc
    IMAGEANLZ.(tab)(axnum0).SetSlice(1);
elseif slice < 1
    IMAGEANLZ.(tab)(axnum0).SetSlice(maxslc);
else
    IMAGEANLZ.(tab)(axnum0).SetSlice(slice);
end

%----------------------------------------
% Update Image
%----------------------------------------
if IMAGEANLZ.(tab)(axnum0).SLCTIE == 1
    start = 1;    
    stop = IMAGEANLZ.(tab)(axnum0).axeslen;
else
    start = axnum0;
    stop = axnum0;
end
for axnum = start:stop
    IMAGEANLZ.(tab)(axnum).SetSlice(IMAGEANLZ.(tab)(axnum0).SLICE);
    if IMAGEANLZ.(tab)(axnum).TestAxisActive 
        IMAGEANLZ.(tab)(axnum).SetImageSlice;
        IMAGEANLZ.(tab)(axnum).PlotImage;
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
for axnum = start:stop
    if IMAGEANLZ.(tab)(axnum).TestAxisActive
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
% Line Related
%----------------------------------------
for axnum = start:stop
    if IMAGEANLZ.(tab)(axnum).TestAxisActive
        if IMAGEANLZ.(tab)(axnum).GETLINE == 1  
            IMAGEANLZ.(tab)(axnum).DrawCurrentLine;
        end   
        if IMAGEANLZ.(tab)(axnum).TestSavedLines
            IMAGEANLZ.(tab)(axnum).DrawSavedLines;
        end
    end
end

%----------------------------------------
% OrthoPresentation 
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).showortholine
    DrawOrthoLines(tab);
end
