%============================================
% Create Box
%============================================
function CreateBox(currentax,tab,axnum,event)

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
    if IMAGEANLZ.(tab)(r).TestAxisActive
        OUT = IMAGEANLZ.(tab)(r).BuildBox(x,y,event);
    end
end
if strcmp(OUT.buttonfunc,'return')
    return
elseif strcmp(OUT.buttonfunc,'updatestatus')
    % do nothing
elseif strcmp(OUT.buttonfunc,'draw')
    for r = start:stop
        if IMAGEANLZ.(tab)(r).TestAxisActive
            IMAGEANLZ.(tab)(r).SetMoveFunction('DrawBox');  
            IMAGEANLZ.(tab)(r).SetInfo(OUT.info);
            IMAGEANLZ.(tab)(r).UpdateStatus;
        end
    end
elseif strcmp(OUT.buttonfunc,'updatefinish')
    for r = start:stop
        if IMAGEANLZ.(tab)(r).TestAxisActive
            [SavedBox,SavedBoxsInd] = IMAGEANLZ.(tab)(r).SaveBox;
            IMAGEANLZ.(tab)(r).UpdateGlobalSavedBoxsInd(SavedBoxsInd);
            IMAGEANLZ.(tab)(r).ClearCurrentBox;    
            IMAGEANLZ.(tab)(r).ClearCurrentBoxData;
            IMAGEANLZ.(tab)(r).WriteSavedBoxData(IMAGEANLZ.(tab)(r).SAVEDBOXS,SavedBox);
            IMAGEANLZ.(tab)(r).SetMoveFunction('');
            IMAGEANLZ.(tab)(r).SetInfo(OUT.info);
            IMAGEANLZ.(tab)(r).UpdateStatus;
        end
    end
elseif strcmp(OUT.buttonfunc,'endtool')
    for r = start:stop
        if IMAGEANLZ.(tab)(r).TestAxisActive
            IMAGEANLZ.(tab)(r).ClearCurrentBox;    
            IMAGEANLZ.(tab)(r).ClearCurrentBoxData;
            IMAGEANLZ.(tab)(r).EndBoxTool;
            IMAGEANLZ.(tab)(r).ResetStatus;
            IMAGEANLZ.(tab)(r).EnableOrient;
            IMAGEANLZ.(tab)(r).FIGOBJS.ActivateBoxTool.BackgroundColor = [0.8,0.8,0.8];
            IMAGEANLZ.(tab)(r).FIGOBJS.ActivateBoxTool.ForegroundColor = [0.149 0.149 0.241];
        end
    end
end
    


