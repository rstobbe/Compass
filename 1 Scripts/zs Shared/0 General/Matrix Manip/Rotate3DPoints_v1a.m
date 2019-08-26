%===========================================
% 
%===========================================

function Vout = Rotate3DPoints_v1a(Vin,thx,thy,thz)

thz=-(thz*pi/180);
thx=-(thx*pi/180);
thy=-(thy*pi/180);

Rz=[cos(thz) -sin(thz) 0;
   sin(thz) cos(thz) 0;
   0 0 1];

Rx=[1 0 0;
    0 cos(thx) -sin(thx);
    0 sin(thx) cos(thx)];

Ry=[cos(thy) 0 sin(thy);
    0 1 0;
    -sin(thy) 0 cos(thy)];

R=Rx*Ry*Rz;

Vout = zeros(3,length(Vin(1,:)));
for n = 1:length(Vin(1,:))
    Vout(:,n) = R*squeeze(Vin(:,n));
end
