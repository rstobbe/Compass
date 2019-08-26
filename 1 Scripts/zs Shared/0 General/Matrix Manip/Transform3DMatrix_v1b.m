%===========================================
% 
%===========================================

function Mout = Transform3DMatrix_v1b(Min,thx,thy,thz,delx,dely,delz)

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

%thz=-(thz*pi/180);
%thx=-(thx*pi/180);
%thy=-(thy*pi/180);

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
   for j=1:y
        for i=1:x
            %val = Min(i,j,k);
            %if abs(val) == 0
            %    continue
            %end
            V = Trans*([i-xc,j-yc,k-zc,1].');
            if floor(V(1)+xc)>0 && floor(V(2)+yc)>0 && floor(V(3)+zc)>0 && ceil(V(1)+xc)<=x && ceil(V(2)+yc)<=y && ceil(V(3)+zc)<=z
                Mout(i,j,k)= trilin_interp(Min,V(1)+xc,V(2)+yc,V(3)+zc); 
            end
        end
    end
end
