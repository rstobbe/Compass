%=============================================
% Zero_Fill k-Space
%   - 'K' must have even dimensions (center of k-space @ xC)
%   - zero-filling is isotropic
%   - (doubles)
%=============================================

function KZ = zerofill_isotropic2D_even_doubles(K,ZF)

[x,y] = size(K);         
KZ = complex(zeros(ZF,ZF,'double'),zeros(ZF,ZF,'double'));

xC = x/2+1;
yC = y/2+1;

KZ(ZF-xC+2:ZF,ZF-yC+2:ZF) = K(xC:x,yC:y);
KZ(1:xC-1,ZF-yC+2:ZF) = K(1:xC-1,yC:y);
KZ(ZF-xC+2:ZF,1:yC-1) = K(xC:x,1:yC-1);
KZ(1:xC-1,1:yC-1) = K(1:xC-1,1:yC-1);



