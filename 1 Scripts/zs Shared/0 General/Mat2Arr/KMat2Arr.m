%==================================================
% In:  (nproj x npro x 3)
% Out: [sp0,sp0,(x nproj),...,sp1,sp1,(x nproj),...]
%==================================================

function [ArrKmat] = KMat2Arr(Kmat,nproj,npro)

ArrKmatx = zeros(nproj*npro,1);
ArrKmaty = zeros(nproj*npro,1);
ArrKmatz = zeros(nproj*npro,1);
for n = 1:npro
    ArrKmatx((n-1)*nproj+1:n*nproj) = Kmat(:,n,1);
    ArrKmaty((n-1)*nproj+1:n*nproj) = Kmat(:,n,2);
    ArrKmatz((n-1)*nproj+1:n*nproj) = Kmat(:,n,3);
end
ArrKmat = [ArrKmatx ArrKmaty ArrKmatz];