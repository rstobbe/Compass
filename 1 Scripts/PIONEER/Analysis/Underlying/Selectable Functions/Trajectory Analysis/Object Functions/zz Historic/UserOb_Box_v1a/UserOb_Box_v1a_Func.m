%===========================================
% 
%===========================================

function [OB,err] = FixedBox_v1a_Func(OB,INPUT)

Status2('busy','Create Sphere',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
ZF = INPUT.zf;
FoV = OB.fov;
x = OB.x;
y = OB.y;
z = OB.z;
clear INPUT

%---------------------------------------------
% Calculate Voxels
%---------------------------------------------
voxdim = FoV/ZF;
xnum = round(x/voxdim);
ynum = round(y/voxdim);
znum = round(z/voxdim);

OB.xactual = xnum*voxdim;
OB.yactual = ynum*voxdim;
OB.zactual = znum*voxdim;
OB.voxdim = voxdim;

Ob = zeros(ZF,ZF,ZF,'single');
bot1 = ceil(xnum/2)-1;
top1 = floor(xnum/2);
bot2 = ceil(ynum/2)-1;
top2 = floor(ynum/2);
bot3 = ceil(znum/2)-1;
top3 = floor(znum/2);
xdim = top1+bot1+1;
ydim = top2+bot2+1;
zdim = top3+bot3+1;
if xdim ~= xnum
    error();
end
if ydim ~= ynum
    error();
end 
if zdim ~= znum
    error();
end 
if xdim > ZF/2 || ydim > ZF/2 || zdim > ZF/2
    err.flag = 1;
    err.msg = 'Increase ZF';
    return
end  

Ob(ZF/2-bot1:ZF/2+top1,ZF/2-bot2:ZF/2+top2,ZF/2-bot3:ZF/2+top3) = 1;   
OB.Ob = Ob;
