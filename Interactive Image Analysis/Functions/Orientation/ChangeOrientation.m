%===================================================
%
%===================================================
function ChangeOrientation(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

if not(IMAGEANLZ.(tab)(axnum).TestAxisActive)
    return
end

% if not(isempty(IMAGEANLZ.(tab)(axnum).buttonfunction))
%     error;          % shouldn't get here
% end

  
%------------------------------------------
% Set Orientation (Orient all insead of Tieing Let-go) 
%------------------------------------------
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    if IMAGEANLZ.(tab)(axnum).TestAllTied
        start = 1;    
        stop = IMAGEANLZ.(tab)(axnum).axeslen;
    else
        start = axnum;
        stop = axnum;
    end
    for r = start:stop    
        IMAGEANLZ.(tab)(r).SetOrient(src.String{src.Value},src.Value);
    end
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    InitializeOrthoPresentation(tab)
end

%----------------------------------------
% Tieing Let-go
%----------------------------------------
% untie = 0;
% for r = 1:IMAGEANLZ.(tab)(axnum).axeslen
%     if not(strcmp(IMAGEANLZ.(tab)(r).ORIENT,IMAGEANLZ.(tab)(axnum).ORIENT))
%         untie = 1;
%         break
%     end
% end
% for r = 1:IMAGEANLZ.(tab)(axnum).axeslen
%     if untie == 1
%         IMAGEANLZ.(tab)(r).TieSlice(0);
%         IMAGEANLZ.(tab)(r).TieZoom(0);
%         IMAGEANLZ.(tab)(r).TieDatVals(0);
%         IMAGEANLZ.(tab)(r).TieCursor(0);
%     end
% end   

%----------------------------------------
% Plot
%----------------------------------------
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    arr = 1:3;
else
    arr = start:stop;
end
for n = arr
    if IMAGEANLZ.(tab)(n).TestAxisActive
        IMAGEANLZ.(tab)(n).ResetScale;
        IMAGEANLZ.(tab)(n).SetMiddleSlice;
        IMAGEANLZ.(tab)(n).SetImage;
        if IMAGEANLZ.(tab)(n).TestForAnyOverlay
            IMAGEANLZ.(tab)(n).SetActiveOverlays;
        end
        IMAGEANLZ.(tab)(n).SetImageSlice;
        IMAGEANLZ.(tab)(n).PlotImage;
        IMAGEANLZ.(tab)(n).SetDataAspectRatio;
        IMAGEANLZ.(tab)(n).DrawSavedROIs([]);
        IMAGEANLZ.(tab)(n).DrawCurrentROI([]);
    end
end

if IMAGEANLZ.(tab)(axnum).showortholine
    DrawOrthoLines(tab);
end

