%=========================================================
% 
%=========================================================

function [GE] = Eddy_Current_Add3(G,T,mag,tau,mag2,tau2,mag3,tau3)

L = length(T)-1; 
%G = G(1,:,3);
%if L == 1
%    max_step = max(G(:));
%else
%    m = (2:L);
%    steps = G(m)-G(m-1);
%    steps = [G(1) steps];
%end
%ecc = -0.2*exp(-T/0.03);
%GE = G;
%for e = 1:L
%    GE(e:L) = steps(e)*ecc(1:L-e+1) + GE(e:L);
%end

if L == 1
    max_step = max(G(:));
else
    m = (2:L);
    steps = G(:,m,:)-G(:,m-1,:);
    steps = [G(:,1,:) steps];
end
ecc = -mag*exp(-T/tau) -mag2*exp(-T/tau2) -mag3*exp(-T/tau3);
GE = G;

for e = 1:L
    GE(:,e:L,1) = steps(:,e,1)*ecc(1:L-e+1) + GE(:,e:L,1);
    GE(:,e:L,2) = steps(:,e,2)*ecc(1:L-e+1) + GE(:,e:L,2);
    GE(:,e:L,3) = steps(:,e,3)*ecc(1:L-e+1) + GE(:,e:L,3);
end
