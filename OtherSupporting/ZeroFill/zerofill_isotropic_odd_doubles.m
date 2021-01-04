%=============================================
% Zero_Fill k-Space
%   - 'K' must have odd dimensions (center of k-space @ (x+1)/2)
%   - zero-filling is isotropic
%   - (doubles)
%=============================================

function KZ = zerofill_isotropic_odd_doubles(K,ZF)

[x,y,z] = size(K);         
KZ = complex(zeros(ZF,ZF,ZF,'double'),zeros(ZF,ZF,ZF,'double'));

KZ(1:(x+1)/2,1:(y+1)/2,1:(z+1)/2) = K(1:(x+1)/2,1:(y+1)/2,1:(z+1)/2);
KZ(ZF-(x+1)/2+2:ZF,ZF-(y+1)/2+2:ZF,ZF-(z+1)/2+2:ZF) = K((x+1)/2+1:x,(y+1)/2+1:y,(z+1)/2+1:z);
KZ(1:(x+1)/2,ZF-(y+1)/2+2:ZF,ZF-(z+1)/2+2:ZF) = K(1:(x+1)/2,(y+1)/2+1:y,(z+1)/2+1:z);
KZ(ZF-(x+1)/2+2:ZF,1:(y+1)/2,ZF-(z+1)/2+2:ZF) = K((x+1)/2+1:x,1:(y+1)/2,(z+1)/2+1:z);
KZ(ZF-(x+1)/2+2:ZF,ZF-(y+1)/2+2:ZF,1:(z+1)/2) = K((x+1)/2+1:x,(y+1)/2+1:y,1:(z+1)/2);
KZ(1:(x+1)/2,1:(y+1)/2,ZF-(z+1)/2+2:ZF) = K(1:(x+1)/2,1:(y+1)/2,(z+1)/2+1:z);
KZ(ZF-(x+1)/2+2:ZF,1:(y+1)/2,1:(z+1)/2) = K((x+1)/2+1:x,1:(y+1)/2,1:(z+1)/2);
KZ(1:(x+1)/2,ZF-(y+1)/2+2:ZF,1:(z+1)/2) = K(1:(x+1)/2,(y+1)/2+1:y,1:(z+1)/2);

