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
elseif strcmp(OUT.buttonfunc,'startline')
    Data.xpt = x;
    Data.ypt = y;
    Data.zpt = 0;
    Data.zpt = IMAGEANLZ.(tab)(axnum).SLICE;
    pixdim = IMAGEANLZ.(tab)(axnum).GetPixelDimensions;
    Data.xloc = (Data.xpt-0.5)*pixdim(2);
    Data.yloc = (Data.ypt-0.5)*pixdim(1);
    Data.zloc = (Data.zpt-0.5)*pixdim(3);
    IMAGEANLZ.(tab)(axnum).NewLineCreateOrthoRoi(Data);
elseif strcmp(OUT.buttonfunc,'restartline')
    IMAGEANLZ.(tab)(1).ClearCurrentLine;
    IMAGEANLZ.(tab)(1).ClearCurrentLineData;
    Data.xpt = x;
    Data.ypt = y;
    Data.zpt = 0;
    Data.zpt = IMAGEANLZ.(tab)(axnum).SLICE;
    pixdim = IMAGEANLZ.(tab)(axnum).GetPixelDimensions;
    Data.xloc = (Data.xpt-0.5)*pixdim(2);
    Data.yloc = (Data.ypt-0.5)*pixdim(1);
    Data.zloc = (Data.zpt-0.5)*pixdim(3);
    IMAGEANLZ.(tab)(axnum).NewLineCreateOrthoRoi(Data);
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
        IMAGEANLZ.(tab)(r).Add2CurrentROIOrtho(IMAGEANLZ.(tab)(axnum).TEMPROI,IMAGEANLZ.(tab)(axnum).ORIENT);
        IMAGEANLZ.(tab)(r).DrawCurrentROILines([]);
        IMAGEANLZ.(tab)(r).SetMoveFunction('');
    end
    drawnow
    for r = 1:3
        IMAGEANLZ.(tab)(r).Add2CurrentROIMask;
        IMAGEANLZ.(tab)(r).DrawCurrentROIShade([]);
        IMAGEANLZ.(tab)(r).ResetTempROI;
        IMAGEANLZ.(tab)(r).SetMoveFunction('');
    end
    IMAGEANLZ.(tab)(1).TestUpdateCurrentROIValue;
    IMAGEANLZ.(tab)(axnum).FIGOBJS.ReturnPanelFunctions; 
    IMAGEANLZ.(tab)(1).ClearCurrentLine;
    IMAGEANLZ.(tab)(1).ClearCurrentLineData;
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

