%==================================================
% Constrain Acceleration (same as ConstAcc_v1)
%==================================================

function [T] = CAccM_v1a(magacc,AccProf,T)

Tsegs = zeros(length(T),1);
for n = 2:length(T)
    Tsegs(n) = sqrt(magacc(n)/AccProf(n))*(T(n)-T(n-1));
end

for n = 2:length(T)
    T(n) = T(n-1) + Tsegs(n);
end

