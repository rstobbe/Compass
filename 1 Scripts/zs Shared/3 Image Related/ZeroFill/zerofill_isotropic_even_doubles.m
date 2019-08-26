%=============================================
% Zero_Fill k-Space
%   - 'K' must have even dimensions (center of k-space @ xC)
%   - zero-filling is isotropic
%   - (doubles)
%=============================================

function KZ = zerofill_isotropic_even_doubles(K,ZF)

[x,y,z] = size(K);         
KZ = complex(zeros(ZF,ZF,ZF,'double'),zeros(ZF,ZF,ZF,'double'));

xC = x/2+1;
yC = y/2+1;
zC = z/2+1;

KZ(ZF-xC+2:ZF,ZF-yC+2:ZF,ZF-zC+2:ZF) = K(xC:x,yC:y,zC:z);
KZ(1:xC-1,ZF-yC+2:ZF,ZF-zC+2:ZF) = K(1:xC-1,yC:y,zC:z);
KZ(ZF-xC+2:ZF,1:yC-1,ZF-zC+2:ZF) = K(xC:x,1:yC-1,zC:z);
KZ(ZF-xC+2:ZF,ZF-yC+2:ZF,1:zC-1) = K(xC:x,yC:y,1:zC-1);
KZ(1:xC-1,1:yC-1,ZF-zC+2:ZF) = K(1:xC-1,1:yC-1,zC:z);
KZ(ZF-xC+2:ZF,1:yC-1,1:zC-1) = K(xC:x,1:yC-1,1:zC-1);
KZ(1:xC-1,ZF-yC+2:ZF,1:zC-1) = K(1:xC-1,yC:y,1:zC-1);
KZ(1:xC-1,1:yC-1,1:zC-1) = K(1:xC-1,1:yC-1,1:zC-1);
