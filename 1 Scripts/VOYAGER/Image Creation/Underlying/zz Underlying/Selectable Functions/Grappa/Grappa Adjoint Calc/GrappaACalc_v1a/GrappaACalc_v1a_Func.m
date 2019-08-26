%=====================================================
%
%=====================================================

function [GACALC,err] = GrappaACalc_v1a_Func(GACALC,INPUT)

Status2('busy','Grappa Adjoint Calculation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G;
clear INPUT;

%---------------------------------------------
% Calculate Adjoint
%---------------------------------------------
Gadjoint = zeros(size(G));
[M,N] = size(G);
L = M/N;
for n = 1:N
    Gadjoint((n-1)*L+1:n*L,:) = G((N-n)*L+1:(N-n+1)*L,:);
end
Gadjoint = flipdim(Gadjoint,1); 
Gadjoint = flipdim(Gadjoint,2);
Gadjoint = conj(Gadjoint);

%---------------------------------------------
% Test
%---------------------------------------------
%testG = G(L+1:2*L,2)
%testGadjoint = Gadjoint(L+1:2*L,N-1)

%---------------------------------------------
% Return
%---------------------------------------------
GACALC.Gadjoint = Gadjoint;

Status2('done','',2);
Status2('done','',3);



