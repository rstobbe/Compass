%===========================================
% 
%===========================================

function [DATCOL,err] = DualPointCollect_v1a_Func(DATCOL,INPUT)

Status2('busy','Collect Data Points',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Im = INPUT.Im;
figno = str2double(INPUT.figno);
clear INPUT
      
%---------------------------------------------
% Get Data
%---------------------------------------------
global glbDATCOL
glbDATCOL.values = [];
glbDATCOL.Im = Im;
scrsz = get(groot,'ScreenSize');
h = helpdlg('First PulseCal (OK when done)','First PulseCal');
pos = get(h,'Position');
pos(1) = 200;
set(h,'Position',pos);
set(figno,'Pointer','crosshair');
set(figno,'Renderer','OpenGL');
set(figno,'WindowButtonDownFcn',@PointCollectButtonClick1);
waitfor(h);
values1 = glbDATCOL.values;
h = helpdlg('Second PulseCal (OK when done)','Second PulseCal');
set(h,'Position',pos);
set(figno,'Pointer','crosshair');
set(figno,'Renderer','OpenGL');
set(figno,'WindowButtonDownFcn',@PointCollectButtonClick2);
waitfor(h);
values2 = glbDATCOL.values;
clear glbDATCOL;

%---------------------------------------------
% Return 
%---------------------------------------------
DATCOL.value = mean(values1);
DATCOL.value2 = mean(values2);

Status2('done','',2);
Status2('done','',3);

