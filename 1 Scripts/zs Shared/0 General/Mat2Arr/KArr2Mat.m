%==================================================
% 
%
%==================================================

function [Kmat] = KArr2Mat(ArrKmat,nproj,npro)

Kmat = zeros(nproj,npro,3);
for n = 1:npro
    Kmat(:,n,1) = ArrKmat((n-1)*nproj+1:n*nproj,1);
    Kmat(:,n,2) = ArrKmat((n-1)*nproj+1:n*nproj,2);
    Kmat(:,n,3) = ArrKmat((n-1)*nproj+1:n*nproj,3);
end
