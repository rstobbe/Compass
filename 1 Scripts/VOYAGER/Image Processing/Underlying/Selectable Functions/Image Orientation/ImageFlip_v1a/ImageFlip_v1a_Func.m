%=========================================================
% 
%=========================================================

function [ORNT,err] = ImageFlip_v1a_Func(ORNT,INPUT)

Status2('busy','Flip Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% Flip
%---------------------------------------------
if str2double(ORNT.flip(1)) == 1
    IMG.Im = flip(IMG.Im,1);
end
if str2double(ORNT.flip(2)) == 1
    IMG.Im = flip(IMG.Im,2);
end
if str2double(ORNT.flip(3)) == 1
    IMG.Im = flip(IMG.Im,3);
end
   
%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',ORNT.method,'Output'};
Panel(3,:) = {'Flip',ORNT.flip,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
if isfield(IMG,'PanelOutput')
    IMG.PanelOutput = [IMG.PanelOutput;PanelOutput];
else
    IMG.PanelOutput = PanelOutput;
end
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
IMG.name = [IMG.name,'_Flip'];
ORNT.IMG = IMG;

Status2('done','',2);
Status2('done','',3);