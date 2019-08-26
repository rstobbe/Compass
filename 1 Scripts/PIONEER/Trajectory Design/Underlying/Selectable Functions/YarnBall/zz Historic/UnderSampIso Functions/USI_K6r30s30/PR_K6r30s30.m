%====================================================
% 
%====================================================

function [G] = PR_K6r30s30(PROJipt)

G = @(r,nproj) func(r,nproj);

function G = func(r,nproj)

beta = 6;
rad = 0.3;
slope = 0.3;

G = zeros(1,length(r));
for n = 1:length(r)
    if r(n) < rad
        G(n) = 1;
    else 
        G(n) = nproj - (nproj-1)*real(besseli(0,beta * sqrt(1 - ((r(n)-rad)/slope).^2))/besseli(0,beta));
    end
end





