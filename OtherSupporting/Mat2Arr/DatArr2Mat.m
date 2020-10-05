%==================================================
% In: [sp0,sp0,(x nproj),...,sp1,sp1,(x nproj),...]
% out:  (nproj x npro)
%==================================================

function [Datmat] = DatArr2Mat(ArrDatmat,nproj,npro)

Datmat = zeros(nproj,npro);
for n = 1:npro
    Datmat(:,n) = ArrDatmat((n-1)*nproj+1:n*nproj);
end
