%==================================================
% 
%
%==================================================

function [SDCmat] = SDCArr2Mat(ArrSDC,nproj,npro)

SDCmat = zeros(nproj,npro);
for n = 1:npro
    SDCmat(:,n) = ArrSDC((n-1)*nproj+1:n*nproj);
end