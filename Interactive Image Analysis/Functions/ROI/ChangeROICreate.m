%===================================================
%
%===================================================
function ChangeROICreate(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
axnum = str2double(src.Tag);

%------------------------------------------
% Setup ROI
%------------------------------------------
IMAGEANLZ.(tab)(axnum).ClearROIPanel;
if src.Value == 1
    IMAGEANLZ.(tab)(axnum).SetROITool('ROIFREEHAND');
elseif src.Value == 2 
    IMAGEANLZ.(tab)(axnum).SetROITool('ROISEED');
elseif src.Value == 3 
    IMAGEANLZ.(tab)(axnum).SetROITool('ROISPHERE');
elseif src.Value == 5 
    IMAGEANLZ.(tab)(axnum).SetROITool('ROITUBE');
elseif src.Value == 6 
    IMAGEANLZ.(tab)(axnum).SetROITool('ROIRECT');
elseif src.Value == 7 
    IMAGEANLZ.(tab)(axnum).SetROITool('ROIBOX');    
end  

%------------------------------------------
% Return Focus (doesnt work for popup)
%------------------------------------------
if not(IMAGEANLZ.(tab)(axnum).TestAxisActive);
    return
end
global FIGOBJS
FIGOBJS.Compass.CurrentAxes = FIGOBJS.(tab).ImAxes(axnum);
FIGOBJS.Compass.CurrentObject = FIGOBJS.(tab).ImAxes(axnum);

