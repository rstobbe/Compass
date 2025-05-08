%===================================================
%
%===================================================
function ShowROICreate(src,event)

global IMAGEANLZ

tab = src.Parent.Tag;
axnum = str2double(src.Tag);
if not(IMAGEANLZ.(tab)(axnum).TestAxisActive);
    return
end

%------------------------------------------
% Find Creation Method
%------------------------------------------
currentregion = src.UserData.currentregion;
ROI = src.UserData.ROI;
CREATEMETHOD = ROI.CREATEMETHOD{currentregion};

%------------------------------------------
% Setup ROI
%------------------------------------------
IMAGEANLZ.(tab)(axnum).ClearROIPanel;
if CREATEMETHOD.roicreatesel == 1
    IMAGEANLZ.(tab)(axnum).SetROITool('ROIFREEHAND');
elseif CREATEMETHOD.roicreatesel == 2 
    IMAGEANLZ.(tab)(axnum).SetROITool('ROISEED');
elseif CREATEMETHOD.roicreatesel == 3 
    IMAGEANLZ.(tab)(axnum).ROISPHERE.Copy(CREATEMETHOD);
    IMAGEANLZ.(tab)(axnum).SetROITool('ROISPHERE');
elseif CREATEMETHOD.roicreatesel == 5 
    IMAGEANLZ.(tab)(axnum).ROITUBE.Copy(CREATEMETHOD);
    IMAGEANLZ.(tab)(axnum).SetROITool('ROITUBE');
elseif CREATEMETHOD.roicreatesel == 6 
    IMAGEANLZ.(tab)(axnum).ROIRECT.Copy(CREATEMETHOD);
    IMAGEANLZ.(tab)(axnum).SetROITool('ROIRECT');
elseif CREATEMETHOD.roicreatesel == 7 
    IMAGEANLZ.(tab)(axnum).ROIBOX.Copy(CREATEMETHOD);
    IMAGEANLZ.(tab)(axnum).SetROITool('ROIBOX');
end  

%------------------------------------------
% Return Focus (doesnt work for popup)
%------------------------------------------
global FIGOBJS
FIGOBJS.Compass.CurrentAxes = FIGOBJS.(tab).ImAxes(axnum);
FIGOBJS.Compass.CurrentObject = FIGOBJS.(tab).ImAxes(axnum);

