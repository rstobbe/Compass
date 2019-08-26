%=============================================
% Zero_Fill k-Space
%   - 'K' must have odd dimensions (center of k-space @ (x+1)/2)
%   - zero-filling is isotropic
%   - (doubles)
%=============================================

function KZ = zerofill_isotropic2D_odd_doubles(K,ZF)

[x,y] = size(K);         
KZ = complex(zeros(ZF,ZF,'double'),zeros(ZF,ZF,'double'));

KZ(1:(x+1)/2,1:(y+1)/2) = K(1:(x+1)/2,1:(y+1)/2);
KZ(ZF-(x+1)/2+2:ZF,ZF-(y+1)/2+2:ZF) = K((x+1)/2+1:x,(y+1)/2+1:y);
KZ(1:(x+1)/2,ZF-(y+1)/2+2:ZF) = K(1:(x+1)/2,(y+1)/2+1:y);
KZ(ZF-(x+1)/2+2:ZF,1:(y+1)/2) = K((x+1)/2+1:x,1:(y+1)/2);


