%=========================================================
% 
%=========================================================

function [ROT,err] = ImageRotationRws_v1b_Func(ROT,INPUT)

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
% Pixel Dimensions
%---------------------------------------------
pixdim = IMG.IMDISP.ImInfo.pixdim;
rpixdim = pixdim/min(pixdim);

%---------------------------------------------
% Rotate
%---------------------------------------------
thz = -ROT.TraRot*pi/180;
thy = ROT.SagRot*pi/180;
thx = -ROT.CorRot*pi/180;

ImReal = Transform3DMatrix(real(squeeze(IMG.Im(:,:,:,1,1,1))),thx,thy,thz,0,0,0,rpixdim);
ImImag = Transform3DMatrix(imag(squeeze(IMG.Im(:,:,:,1,1,1))),thx,thy,thz,0,0,0,rpixdim);
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


%=========================================================
% 
%=========================================================
function Mout = Transform3DMatrix(Min,thx,thy,thz,delx,dely,delz,rpixdim)

[x,y,z]=size(Min);     
if rem(x,2)
    xc=(x+1)/2;
    yc=(y+1)/2;
    zc=(z+1)/2;
else
    xc=(x)/2;
    yc=(y)/2;
    zc=(z)/2;
end

Rz=[cos(thz) -sin(thz) 0 0;
   sin(thz) cos(thz) 0 0;
   0 0 1 0;
   0 0 0 1;];

Rx=[1 0 0 0;
    0 cos(thx) -sin(thx) 0;
    0 sin(thx) cos(thx) 0;
    0 0 0 1;];

Ry=[cos(thy) 0 sin(thy) 0;
    0 1 0 0;
    -sin(thy) 0 cos(thy) 0;
    0 0 0 1;];

T=[1 0 0 delx;
   0 1 0 dely;
   0 0 1 delz;
   0 0 0 1];

Trans=Rx*Ry*Rz*T;

Mout=zeros(size(Min));
rz = rpixdim(3);
ry = rpixdim(2);
rx = rpixdim(1);
parfor k=1:z
   for j=1:y
        for i=1:x
            %val = Min(i,j,k);
            %if abs(val) == 0
            %    continue
            %end
            V = Trans*([(i-xc)*rx,(j-yc)*ry,(k-zc)*rz,1].');
            if floor(V(1)/rx+xc)>0 && floor(V(2)/ry+yc)>0 && floor(V(3)/rz+zc)>0 && ceil(V(1)/rx+xc)<=x && ceil(V(2)/ry+yc)<=y && ceil(V(3)/rz+zc)<=z
                Mout(i,j,k)= trilin_interp(Min,V(1)/rx+xc,V(2)/ry+yc,V(3)/rz+zc); 
            end
        end
    end
end







