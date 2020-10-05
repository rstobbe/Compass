%==================================================
% MV = multi-volume
% In: [sp0,sp0,(x nproj),...,sp1,sp1,(x nproj),...]
% out:  (nproj x npro)
%==================================================

function [Datmat] = DatArr2MatMV(ArrDatmat,nproj,npro)

sz = size(ArrDatmat);
nvols = sz(2);

Datmat = zeros(nproj,npro,nvols);
for n = 1:npro
    Datmat(:,n,:) = ArrDatmat((n-1)*nproj+1:n*nproj,:);
end
