%==================================================
% Constrain Acceleration
%==================================================

function [T] = ConstAcc_v1(magacc,AccProf,T)

Tsegs = zeros(length(T),1);
for n = 2:length(T)
    Tsegs(n) = sqrt(magacc(n)/AccProf(n))*(T(n)-T(n-1));
end

for n = 2:length(T)
    T(n) = T(n-1) + Tsegs(n);
end

