%=====================================================
% SolveGradQuant
%=====================================================

function [G] = SolveGradQuant(AIDrp,T,GQKSA,gamma)

error('historic');

%nproj = AIDrp.nproj;
nproj = length(GQKSA(:,1,1));
G = zeros(nproj,length(T)-1,3);

for n = 1:nproj 
    Status('busy',['Solving Gradient Quantization - Projection Number: ',num2str(n)]);
    for p = 1:3
        for m = 2:length(T)
            G(n,m-1,p) = ((GQKSA(n,m,p)-GQKSA(n,m-1,p))/(T(m)-T(m-1)))/gamma;
        end
    end
end

