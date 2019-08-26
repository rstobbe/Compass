%===========================================
% 
%===========================================

function Mout = Transform3DMatrix_v1a(Min,thx,thy,thz,delx,dely,delz)

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

T=[1 0 0 delx;
   0 1 0 dely;
   0 0 1 delz;
   0 0 0 1];

Trans=Rx*Ry*Rz*T;

Mout=zeros(size(Min));
for k=1:z
   for i=1:x
        for j=1:y
            ii=(Trans(1,1)*(i-xc))+(Trans(1,2)*(j-yc))+(Trans(1,3)*(k-zc))+xc;
            jj=(Trans(2,1)*(i-xc))+(Trans(2,2)*(j-yc))+(Trans(2,3)*(k-zc))+yc;
            kk=(Trans(3,1)*(i-xc))+(Trans(3,2)*(j-yc))+(Trans(3,3)*(k-zc))+zc;
            
            if floor(ii)>0 && floor(jj)>0 && floor(kk)>0 && ceil(ii)<=x && ceil(jj)<=y && ceil(kk)<=z
                Mout(i,j,k)= trilin_interp(Min,ii,jj,kk); 
            end
        end
    end
end
