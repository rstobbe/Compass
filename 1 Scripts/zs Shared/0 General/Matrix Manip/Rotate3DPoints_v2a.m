%===========================================
% v1a 
% - radians
%===========================================

function Vout = Rotate3DPointsAboutZ_v1a(Vin,phi,theta)

R = [cos(phi) -sin(phi) 0;
     sin(phi) cos(phi) 0;
     0 0 1];

Vout = zeros(size(Vin));
for n = 1:length(Vin(:,1))
    Vout(n,:) = R*(squeeze(Vin(n,:)).');
end
