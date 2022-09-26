%============================================
% Create ROI
%============================================
function CreateROI(currentax,tab,axnum,event)

global IMAGEANLZ

%----------------------------------------
% Get Data
%----------------------------------------
pt = currentax.CurrentPoint;
x = pt(1,1);
y = pt(1,2);

%----------------------------------------
% RoiTie
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).ROITIE == 1
    start = 1;    
    stop = IMAGEANLZ.(tab)(axnum).axeslen;
else
    start = axnum;
    stop = axnum;
end

%---
showcurrentroionall = 1;            % to switch on panel
%---

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
elseif strcmp(OUT.buttonfunc,'startline')
    Data.xpt = x;
    Data.ypt = y;
    Data.zpt = 0;
    Data.zpt = IMAGEANLZ.(tab)(axnum).SLICE;
    pixdim = IMAGEANLZ.(tab)(axnum).GetPixelDimensions;
    Data.xloc = (Data.xpt-0.5)*pixdim(2);
    Data.yloc = (Data.ypt-0.5)*pixdim(1);
    Data.zloc = (Data.zpt-0.5)*pixdim(3);
    for r = start:stop
        IMAGEANLZ.(tab)(r).NewLineCreateRoi(Data);
    end
elseif strcmp(OUT.buttonfunc,'restartline')
    Data.xpt = x;
    Data.ypt = y;
    Data.zpt = 0;
    Data.zpt = IMAGEANLZ.(tab)(axnum).SLICE;
    pixdim = IMAGEANLZ.(tab)(axnum).GetPixelDimensions;
    Data.xloc = (Data.xpt-0.5)*pixdim(2);
    Data.yloc = (Data.ypt-0.5)*pixdim(1);
    Data.zloc = (Data.zpt-0.5)*pixdim(3);
    for r = start:stop
        IMAGEANLZ.(tab)(r).ClearCurrentLine;
        IMAGEANLZ.(tab)(r).ClearCurrentLineData;
        IMAGEANLZ.(tab)(r).NewLineCreateRoi(Data);
    end
elseif strcmp(OUT.buttonfunc,'updateregion')
    if showcurrentroionall == 1
        for r = start:stop
            if IMAGEANLZ.(tab)(r).TestAxisActive
                IMAGEANLZ.(tab)(r).UpdateTempROI(OUT);
                IMAGEANLZ.(tab)(r).DrawTempROI([],OUT.clr);
            end
        end
    else
        IMAGEANLZ.(tab)(axnum).UpdateTempROI(OUT);
        IMAGEANLZ.(tab)(axnum).DrawTempROI([],OUT.clr);
    end 
    for r = start:stop    
        if IMAGEANLZ.(tab)(r).TestAxisActive
            if IMAGEANLZ.(tab)(r).autoupdateroi 
                IMAGEANLZ.(tab)(r).UpdateTempROIValues;
            end
        end
    end 
    for r = start:stop
        if IMAGEANLZ.(tab)(r).TestForCurrentLine
            IMAGEANLZ.(tab)(r).ClearCurrentLine;
            IMAGEANLZ.(tab)(r).ClearCurrentLineData;
            IMAGEANLZ.(tab)(r).SetMoveFunction('');
        end
    end
elseif strcmp(OUT.buttonfunc,'updatefinish')
    IMAGEANLZ.(tab)(axnum).UpdateTempROI(OUT);
    for r = start:stop
        if IMAGEANLZ.(tab)(r).TestAxisActive
            IMAGEANLZ.(tab)(r).Add2CurrentROI(IMAGEANLZ.(tab)(axnum).TEMPROI);
        end
    end
    for r = start:stop
        if IMAGEANLZ.(tab)(r).TestAxisActive
            IMAGEANLZ.(tab)(r).ResetTempROI;
            IMAGEANLZ.(tab)(r).SetMoveFunction('');
        end
    end
    if showcurrentroionall == 1
        for r = start:stop
            if IMAGEANLZ.(tab)(r).TestAxisActive
                IMAGEANLZ.(tab)(r).TestUpdateCurrentROIValue;
                IMAGEANLZ.(tab)(r).DrawCurrentROI([]);
            end
        end
        IMAGEANLZ.(tab)(axnum).TestUpdateCurrentROIValue;               % retain this focus
    else
        IMAGEANLZ.(tab)(axnum).DrawCurrentROI([]); 
    end
    IMAGEANLZ.(tab)(axnum).FIGOBJS.ReturnPanelFunctions;
    for r = start:stop
        if IMAGEANLZ.(tab)(r).TestForCurrentLine
            IMAGEANLZ.(tab)(r).ClearCurrentLine;
            IMAGEANLZ.(tab)(r).ClearCurrentLineData;
        end
    end
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

