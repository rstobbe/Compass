%=========================================================
% 
%=========================================================

function [ROT,err] = ImageRotation_v1b_Func(ROT,INPUT)

Status2('busy','Rotate Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% Rotation Matrix
%---------------------------------------------
thz=(ROT.TraRot*pi/180);
thx=-(ROT.SagRot*pi/180);
thy=-(ROT.CorRot*pi/180);

Rz=[cos(thz) -sin(thz) 0 0;
   sin(thz) cos(thz) 0 0;
   0 0 1 0;
   0 0 0 1;];

Rx=[1 0 0 0;
    0 cos(thx) -sin(thx) 0;
    0 sin(thx) cos(thx) 0;
    0 0 0 1;];

Ry=[cos(thy) 0 -sin(thy) 0;
    0 1 0 0;
    sin(thy) 0 cos(thy) 0;
    0 0 0 1;];

R=Rx*Ry*Rz;
TForm = affine3d(R);

%---------------------------------------------
% Rotate
%---------------------------------------------
ImReal = imwarp(real(squeeze(IMG.Im(:,:,:,1,1,1))),TForm);
ImImag = imwarp(imag(squeeze(IMG.Im(:,:,:,1,1,1))),TForm);
IMG.Im = ImReal + 1i*ImImag;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',ROT.method,'Output'};
Panel(3,:) = {'TraRot',ROT.TraRot,'Output'};
Panel(4,:) = {'SagRot',ROT.SagRot,'Output'};
Panel(5,:) = {'CorRot',ROT.CorRot,'Output'};
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
IMG.name = [IMG.name,'_Rot'];
ROT.IMG = IMG;

Status2('done','',2);
Status2('done','',3);
