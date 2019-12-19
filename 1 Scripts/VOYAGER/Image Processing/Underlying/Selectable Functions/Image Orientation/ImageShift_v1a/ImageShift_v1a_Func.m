%=========================================================
% 
%=========================================================

function [ORNT,err] = ImageShift_v1a_Func(ORNT,INPUT)

Status2('busy','Shift Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% Get Input
%---------------------------------------------
ind = strfind(ORNT.shift,',');
shift(1) = str2double(ORNT.shift(1:ind(1)-1));
shift(2) = str2double(ORNT.shift(ind(1)+1:ind(2)-1));
shift(3) = str2double(ORNT.shift(ind(2)+1:end));

%---------------------------------------------
% Shift
%---------------------------------------------
IMG.Im = circshift(IMG.Im,shift);

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',ORNT.method,'Output'};
Panel(3,:) = {'Shift',ORNT.shift,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMG.PanelOutput = [IMG.PanelOutput;PanelOutput];
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
IMG.IMDISP.ImInfo.info = IMG.ExpDisp;

%---------------------------------------------
% Return
%---------------------------------------------
if strfind(IMG.name,'.mat') 
    IMG.name = IMG.name(1:end-4);
end
if strfind(IMG.name,'.nii') 
    IMG.name = IMG.name(1:end-4);
end
if strfind(IMG.name,'.hdr') 
    IMG.name = IMG.name(1:end-4);
end
IMG.name = [IMG.name,'_Shift'];
ORNT.IMG = IMG;

Status2('done','',2);
Status2('done','',3);