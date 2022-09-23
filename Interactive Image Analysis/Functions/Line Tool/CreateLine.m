%============================================
% Create Line
%============================================
function CreateLine(currentax,tab,axnum,event)

global IMAGEANLZ

%----------------------------------------
% Get Data
%----------------------------------------
pt = currentax.CurrentPoint;
x = pt(1,1);
y = pt(1,2);

if IMAGEANLZ.(tab)(axnum).ROITIE == 1
    start = 1;    
    stop = IMAGEANLZ.(tab)(axnum).axeslen;
else
    start = axnum;
    stop = axnum;
end

%----------------------------------------
% Build ROI
%----------------------------------------
for r = start:stop
    OUT = IMAGEANLZ.(tab)(r).BuildLine(x,y,event);
end
if strcmp(OUT.buttonfunc,'return')
    return
elseif strcmp(OUT.buttonfunc,'updatestatus')
    % do nothing
elseif strcmp(OUT.buttonfunc,'draw')
    for r = start:stop
        IMAGEANLZ.(tab)(r).SetMoveFunction('DrawLine');  
        IMAGEANLZ.(tab)(r).SetInfo(OUT.info);
        IMAGEANLZ.(tab)(r).UpdateStatus;
    end
elseif strcmp(OUT.buttonfunc,'updatefinish')
    for r = start:stop
        [SavedLine,SavedLinesInd] = IMAGEANLZ.(tab)(r).SaveLine;
        IMAGEANLZ.(tab)(r).UpdateGlobalSavedLinesInd(SavedLinesInd);
        IMAGEANLZ.(tab)(r).ClearCurrentLine;    
        IMAGEANLZ.(tab)(r).ClearCurrentLineData;
        IMAGEANLZ.(tab)(r).WriteSavedLineData(IMAGEANLZ.(tab)(r).SAVEDLINES,SavedLine);
        IMAGEANLZ.(tab)(r).SetMoveFunction('');
        IMAGEANLZ.(tab)(r).SetInfo(OUT.info);
        IMAGEANLZ.(tab)(r).UpdateStatus;
    end
elseif strcmp(OUT.buttonfunc,'endtool')
    for r = start:stop
        IMAGEANLZ.(tab)(r).ClearCurrentLine;    
        IMAGEANLZ.(tab)(r).ClearCurrentLineData;
        IMAGEANLZ.(tab)(r).EndLineTool;
        IMAGEANLZ.(tab)(r).ResetStatus;
        IMAGEANLZ.(tab)(r).EnableOrient;
        IMAGEANLZ.(tab)(r).FIGOBJS.ActivateLineTool.BackgroundColor = [0.8,0.8,0.8];
        IMAGEANLZ.(tab)(r).FIGOBJS.ActivateLineTool.ForegroundColor = [0.149 0.149 0.241];
    end
end
    


