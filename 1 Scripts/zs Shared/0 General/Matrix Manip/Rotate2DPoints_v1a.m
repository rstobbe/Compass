%===========================================
% v1a 
%  (theta in radians)
%===========================================

function Vout = Rotate2DPoints_v1a(Vin,theta)

R = [cos(theta) -sin(theta);
     sin(theta) cos(theta)];

Vout = zeros(size(Vin));
for n = 1:length(Vin(:,1))
    Vout(n,:) = R*(squeeze(Vin(n,:)).');
end
