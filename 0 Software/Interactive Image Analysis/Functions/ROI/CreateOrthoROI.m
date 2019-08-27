%============================================
% Create ROI
%============================================
function CreateOrthoROI(currentax,tab,axnum,event)

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
OUT = IMAGEANLZ.(tab)(axnum).BuildROI(x,y,event);
if strcmp(OUT.buttonfunc,'return')
    return
elseif strcmp(OUT.buttonfunc,'updatestatus')
    % do nothing
elseif strcmp(OUT.buttonfunc,'draw')
    IMAGEANLZ.(tab)(axnum).SetMoveFunction('DrawROI');  
elseif strcmp(OUT.buttonfunc,'updateregion')
    for r = 1:3
        IMAGEANLZ.(tab)(r).UpdateTempROI(OUT);
        IMAGEANLZ.(tab)(r).DrawTempROI([],OUT.clr);
    end 
    if IMAGEANLZ.(tab)(1).autoupdateroi 
        IMAGEANLZ.(tab)(1).UpdateTempROIValues;
    end
elseif strcmp(OUT.buttonfunc,'updatefinish')
    IMAGEANLZ.(tab)(axnum).UpdateTempROI(OUT);
    for r = 1:3
        IMAGEANLZ.(tab)(r).Add2CurrentROI(IMAGEANLZ.(tab)(axnum).TEMPROI);
    end
    IMAGEANLZ.(tab)(1).TestUpdateCurrentROIValue;
    for r = 1:3
        IMAGEANLZ.(tab)(r).ResetTempROI;
        IMAGEANLZ.(tab)(r).DrawCurrentROI([]);
        IMAGEANLZ.(tab)(r).SetMoveFunction('');
    end
    IMAGEANLZ.(tab)(axnum).FIGOBJS.ReturnPanelFunctions; 
elseif strcmp(OUT.buttonfunc,'addregion')
    error;   %update
    IMAGEANLZ.(tab)(axnum).TEMPROI.AddNewRegion(IMAGEANLZ.(tab)(axnum).(IMAGEANLZ.(tab)(axnum).activeroi));
elseif strcmp(OUT.buttonfunc,'updateaddregion')
    error  % delete??
elseif strcmp(OUT.buttonfunc,'deleteupdatefinish')
    error  % delete?? (use updatefinish)
end

IMAGEANLZ.(tab)(axnum).SetInfo(OUT.info);
IMAGEANLZ.(tab)(axnum).UpdateStatus;

