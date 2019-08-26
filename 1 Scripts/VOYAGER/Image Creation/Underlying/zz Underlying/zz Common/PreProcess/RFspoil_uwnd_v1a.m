%=====================================================
%
%=====================================================

function [Dat] = RFspoil_uwnd_v1a(Dat,dummies,rfspoil)

for n = 1:length(Dat(:,1))                                            
    Dat(n,:) = Dat(n,:) * exp(1i*(rfspoil/180)*pi*(n+dummies-1));      % Adjust for RF spoil phase shift
end

