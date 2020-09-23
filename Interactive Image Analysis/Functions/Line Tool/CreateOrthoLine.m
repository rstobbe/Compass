%============================================
% Create Line
%============================================
function CreateOrthoLine(currentax,tab,axnum,event)

global IMAGEANLZ

%----------------------------------------
% Get Data
%----------------------------------------
pt = currentax.CurrentPoint;
x = pt(1,1);
y = pt(1,2);

%----------------------------------------
% Build ROI
%----------------------------------------
OUT = IMAGEANLZ.(tab)(axnum).BuildLine(x,y,event);
if strcmp(OUT.buttonfunc,'return')
    return
elseif strcmp(OUT.buttonfunc,'updatestatus')
    % do nothing
elseif strcmp(OUT.buttonfunc,'draw')
    IMAGEANLZ.(tab)(axnum).SetMoveFunction('DrawLine');  
    IMAGEANLZ.(tab)(axnum).SetInfo(OUT.info);
    IMAGEANLZ.(tab)(axnum).UpdateStatus;
elseif strcmp(OUT.buttonfunc,'updatefinish')
    [SavedLine,SavedLinesInd] = IMAGEANLZ.(tab)(axnum).SaveLine;
    for r = 1:3
        IMAGEANLZ.(tab)(r).UpdateGlobalSavedLinesInd(SavedLinesInd);
    end
    IMAGEANLZ.(tab)(axnum).ClearCurrentLine;    
    IMAGEANLZ.(tab)(1).ClearCurrentLineData;
    IMAGEANLZ.(tab)(1).WriteSavedLineData(IMAGEANLZ.(tab)(axnum).SAVEDLINES,SavedLine);
    IMAGEANLZ.(tab)(axnum).SetMoveFunction('');
    IMAGEANLZ.(tab)(axnum).SetInfo(OUT.info);
    IMAGEANLZ.(tab)(axnum).UpdateStatus;
elseif strcmp(OUT.buttonfunc,'endtool')
    IMAGEANLZ.(tab)(axnum).ClearCurrentLine;    
    IMAGEANLZ.(tab)(1).ClearCurrentLineData;
    for r = 1:3
        IMAGEANLZ.(tab)(r).EndLineTool;
        IMAGEANLZ.(tab)(r).ResetStatus;
    end
    IMAGEANLZ.(tab)(1).EnableOrient;
    IMAGEANLZ.(tab)(1).FIGOBJS.ActivateLineTool.BackgroundColor = [0.8,0.8,0.8];
    IMAGEANLZ.(tab)(1).FIGOBJS.ActivateLineTool.ForegroundColor = [0.149 0.149 0.241];
end
    


