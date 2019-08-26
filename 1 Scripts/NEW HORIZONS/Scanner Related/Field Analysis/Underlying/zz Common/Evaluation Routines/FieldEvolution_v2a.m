%====================================================
% (v2a) removed visualization stuff
%====================================================

function [Bloc1,Bloc2] = FieldEvolution_v2a(PH1,PH2,expT)

dwell = expT(2) - expT(1);
[numexps,np,len] = size(PH1);
Bloc1 = zeros(numexps,np,len);
Bloc2 = zeros(numexps,np,len);
for n = 1:numexps
    for p = 1:len
        for m = 2:np
            Bloc1(n,m-1,p) = (PH1(n,m,p) - PH1(n,m-1,p))/(2*pi*dwell*42.577); % should be in mT
            Bloc2(n,m-1,p) = (PH2(n,m,p) - PH2(n,m-1,p))/(2*pi*dwell*42.577);
        end
    end
end