%=============================================
% Zero_Fill k-Space
%   - 'K' must have odd dimensions (center of k-space @ (x+1)/2)
%   - zero-filling is isotropic
%   - (doubles)
%=============================================

function KZ = zerofill_isotropic_odd_doubles_v1b(K,ZF)

[x,y,z] = size(K);  

if not(rem(x,2)) || not(rem(y,2)) || not(rem(z,2))
    error();
end

KZ = complex(zeros(ZF,ZF,ZF,'double'),zeros(ZF,ZF,ZF,'double'));

xC = round((x+1)/2);
yC = round((y+1)/2);
zC = round((z+1)/2);

KZ(1:xC,1:yC,1:zC) = K(1:xC,1:yC,1:zC);
KZ(ZF-xC+2:ZF,ZF-yC+2:ZF,ZF-zC+2:ZF) = K(xC+1:x,yC+1:y,zC+1:z);
KZ(1:xC,ZF-yC+2:ZF,ZF-zC+2:ZF) = K(1:xC,yC+1:y,zC+1:z);
KZ(ZF-xC+2:ZF,1:yC,ZF-zC+2:ZF) = K(xC+1:x,1:yC,zC+1:z);
KZ(ZF-xC+2:ZF,ZF-yC+2:ZF,1:zC) = K(xC+1:x,yC+1:y,1:zC);
KZ(1:xC,1:yC,ZF-zC+2:ZF) = K(1:xC,1:yC,zC+1:z);
KZ(ZF-xC+2:ZF,1:yC,1:zC) = K(xC+1:x,1:yC,1:zC);
KZ(1:xC,ZF-yC+2:ZF,1:zC) = K(1:xC,yC+1:y,1:zC);

