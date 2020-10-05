%==================================================
% MV = multi-volume
% In:  (nproj x npro x MV)
% Out: [sp0,sp0,(x nproj),...,sp1,sp1,(x nproj),...]
%==================================================

function [ArrDat] = DatMat2ArrMV(Dat)

sz = size(Dat);
nproj = sz(1);
npro = sz(2);
nvols = sz(3);

ArrDat = zeros(nproj*npro,nvols);
for n = 1:npro
    ArrDat((n-1)*nproj+1:n*nproj,:) = Dat(:,n,:);
end
