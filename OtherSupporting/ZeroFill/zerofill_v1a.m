%=============================================
% Zero_Fill k-Space
%   - 'kmat' must have even dimensions (center of k-space @ xC)
%   - (doubles)
%=============================================

function kzf = zerofill_v1a(kmat,zfdims)

[x,y,z] = size(kmat);   
xC = x/2+1;
yC = y/2+1;
zC = z/2+1;

xzf = zfdims.x;
yzf = zfdims.y;
zzf = zfdims.z;
kzf = complex(zeros(zfdims.x,zfdims.y,zfdims.z,'double'),zeros(zfdims.x,zfdims.y,zfdims.z,'double'));

kzf(xzf-xC+2:xzf,yzf-yC+2:yzf,zzf-zC+2:zzf) = kmat(xC:x,yC:y,zC:z);
kzf(1:xC-1,yzf-yC+2:yzf,zzf-zC+2:zzf) = kmat(1:xC-1,yC:y,zC:z);
kzf(xzf-xC+2:xzf,1:yC-1,zzf-zC+2:zzf) = kmat(xC:x,1:yC-1,zC:z);
kzf(xzf-xC+2:xzf,yzf-yC+2:yzf,1:zC-1) = kmat(xC:x,yC:y,1:zC-1);
kzf(1:xC-1,1:yC-1,zzf-zC+2:zzf) = kmat(1:xC-1,1:yC-1,zC:z);
kzf(xzf-xC+2:xzf,1:yC-1,1:zC-1) = kmat(xC:x,1:yC-1,1:zC-1);
kzf(1:xC-1,yzf-yC+2:yzf,1:zC-1) = kmat(1:xC-1,yC:y,1:zC-1);
kzf(1:xC-1,1:yC-1,1:zC-1) = kmat(1:xC-1,1:yC-1,1:zC-1);
