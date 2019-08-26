%======================================================
% 
%======================================================

function [OB,voxdim,TSTipt,err] = FixedBox(TSTipt,ZF,err)

FoV = str2double(TSTipt(strcmp('FoV (mm)',{TSTipt.labelstr})).entrystr);
x = str2double(TSTipt(strcmp('x (mm)',{TSTipt.labelstr})).entrystr);
y = str2double(TSTipt(strcmp('y (mm)',{TSTipt.labelstr})).entrystr);
z = str2double(TSTipt(strcmp('z (mm)',{TSTipt.labelstr})).entrystr);

voxdim = FoV/ZF;
xnum = round(x/voxdim);
ynum = round(y/voxdim);
znum = round(z/voxdim);

TSTipt(strcmp('x (mm)',{TSTipt.labelstr})).entrystr = num2str(xnum*voxdim);
TSTipt(strcmp('y (mm)',{TSTipt.labelstr})).entrystr = num2str(ynum*voxdim);
TSTipt(strcmp('z (mm)',{TSTipt.labelstr})).entrystr = num2str(znum*voxdim);

OB = zeros(ZF,ZF,ZF,'single');
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
    if length(err) ~= 1
        errn = length(err)+1;
    else
        errn = 1;
    end
    err(errn).flag = 1;
    err(errn).msg = 'Increase ZF';
    return
end  

OB(ZF/2-bot1:ZF/2+top1,ZF/2-bot2:ZF/2+top2,ZF/2-bot3:ZF/2+top3) = 1;   

