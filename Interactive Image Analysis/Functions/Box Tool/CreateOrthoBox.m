%============================================
% Create Box
%============================================
function CreateOrthoBox(currentax,tab,axnum,event)

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
OUT = IMAGEANLZ.(tab)(axnum).BuildBox(x,y,event);
if strcmp(OUT.buttonfunc,'return')
    return
elseif strcmp(OUT.buttonfunc,'updatestatus')
    % do nothing
elseif strcmp(OUT.buttonfunc,'draw')
    IMAGEANLZ.(tab)(axnum).SetMoveFunction('DrawBox');  
    IMAGEANLZ.(tab)(axnum).SetInfo(OUT.info);
    IMAGEANLZ.(tab)(axnum).UpdateStatus;
elseif strcmp(OUT.buttonfunc,'updatefinish')
    [SavedBox,SavedBoxsInd] = IMAGEANLZ.(tab)(axnum).SaveBox;
    for r = 1:3
        IMAGEANLZ.(tab)(r).UpdateGlobalSavedBoxsInd(SavedBoxsInd);
    end
    IMAGEANLZ.(tab)(axnum).ClearCurrentBox;    
    IMAGEANLZ.(tab)(1).ClearCurrentBoxData;
    IMAGEANLZ.(tab)(1).WriteSavedBoxData(IMAGEANLZ.(tab)(axnum).SAVEDBOXS,SavedBox);
    IMAGEANLZ.(tab)(axnum).SetMoveFunction('');
    IMAGEANLZ.(tab)(axnum).SetInfo(OUT.info);
    IMAGEANLZ.(tab)(axnum).UpdateStatus;
elseif strcmp(OUT.buttonfunc,'endtool')
    IMAGEANLZ.(tab)(axnum).ClearCurrentBox;    
    IMAGEANLZ.(tab)(1).ClearCurrentBoxData;
    for r = 1:3
        IMAGEANLZ.(tab)(r).EndBoxTool;
        IMAGEANLZ.(tab)(r).ResetStatus;
    end
    IMAGEANLZ.(tab)(1).EnableOrient;
    IMAGEANLZ.(tab)(1).FIGOBJS.ActivateBoxTool.BackgroundColor = [0.8,0.8,0.8];
    IMAGEANLZ.(tab)(1).FIGOBJS.ActivateBoxTool.ForegroundColor = [0.149 0.149 0.241];
end
    


