%==================================================
% In:  (nproj x npro)
% Out: [sp0,sp0,(x nproj),...,sp1,sp1,(x nproj),...]
%==================================================

function [ArrDat] = DatMat2Arr(Dat,nproj,npro)

ArrDat = zeros(nproj*npro,1);
for n = 1:npro
    ArrDat((n-1)*nproj+1:n*nproj) = Dat(:,n);
end
