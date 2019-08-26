%===========================================
% 
%===========================================

function [DATCOL,err] = PointCollect_v1a_Func(DATCOL,INPUT)

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
set(figno,'Pointer','crosshair');
set(figno,'Renderer','OpenGL');
set(figno,'WindowButtonDownFcn',@PointCollectButtonClick);
waitfor(figno);
values = glbDATCOL.values;
clear glbDATCOL;

%---------------------------------------------
% Return 
%---------------------------------------------
DATCOL.value = mean(values);


Status2('done','',2);
Status2('done','',3);

