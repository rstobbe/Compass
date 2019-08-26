%==================================================
% In:  (nproj x npro)
% Out: [sp0,sp0,(x nproj),...,sp1,sp1,(x nproj),...]
%==================================================

function [ArrSDC] = SDCMat2Arr(SDC,nproj,npro)

ArrSDC = zeros(nproj*npro,1);
for n = 1:npro
    ArrSDC((n-1)*nproj+1:n*nproj) = SDC(:,n);
end
