%===========================================
% v1a 
% - radians
%===========================================

function Vout = Rotate3DPointsAboutZ_v1a(Vin,theta)

R = [cos(theta) -sin(theta) 0;
     sin(theta) cos(theta) 0;
     0 0 1];

Vout = zeros(size(Vin));
for n = 1:length(Vin(:,1))
    Vout(n,:) = R*(squeeze(Vin(n,:)).');
end
