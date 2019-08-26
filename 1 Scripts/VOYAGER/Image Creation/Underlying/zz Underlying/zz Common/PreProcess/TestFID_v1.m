%=====================================================
% 
%=====================================================

function [Dcent_test,Dsum_test] = TestFID_v1(DAT,np)


tnp = length(DAT);
Dsum_test = zeros(1,np);

%---------------------------------
% Testing
%---------------------------------
Dcent_test = DAT(1:np:tnp);
for j = 1:np
    Dsum_test(j) = sum(DAT(j:np:tnp));
end

figure(10);
hold on
plot(real(Dsum_test),'b-');
title('Check for Refocussing Effects In Readout');
%figure(11);
%hold on
%plot(abs(Dcent_test(:)),'-');
%title('First Point of Projection Test');
%figure(12)
%plot(angle(Dcent_test(:)),'-');
%title('First Point of Projection Test (phase)');