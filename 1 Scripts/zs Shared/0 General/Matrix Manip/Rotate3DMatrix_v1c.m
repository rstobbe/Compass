%===========================================
% 
%===========================================

function Mout = Rotate3DMatrix_v1c(Min,thx,thy,thz)

[x,y,z]=size(Min);     
if (rem(x,2))
    error('the dimensions of Min must be even');
end
xc=(x)/2;
yc=(y)/2;
zc=(z)/2;
%xc=(x+2)/2;
%yc=(y+2)/2;
%zc=(z+2)/2;

thz=-(thz*pi/180);
thx=-(thx*pi/180);
thy=-(thy*pi/180);

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

R=Rx*Ry*Rz;

Mout=zeros(size(Min));
for k=1:z
   for i=1:x
        for j=1:y
            ii=(R(1,1)*(i-xc))+(R(1,2)*(j-yc))+(R(1,3)*(k-zc))+xc;
            jj=(R(2,1)*(i-xc))+(R(2,2)*(j-yc))+(R(2,3)*(k-zc))+yc;
            kk=(R(3,1)*(i-xc))+(R(3,2)*(j-yc))+(R(3,3)*(k-zc))+zc;
            
            if floor(ii)>0 && floor(jj)>0 && floor(kk)>0 && ceil(ii)<=x && ceil(jj)<=y && ceil(kk)<=z
                Mout(i,j,k)= trilin_interp(Min,ii,jj,kk); 
            end
        end
    end
end
