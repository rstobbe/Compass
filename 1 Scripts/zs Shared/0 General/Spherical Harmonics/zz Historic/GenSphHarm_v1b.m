%======================================================
% (v1a)
%
%======================================================

function GenSphHarm_v1b(degree,order,phi,theta)

degree = 3;
order = 1;
theta = 0.5;
phi = 0.5;

Ytemp = legendre(degree,cos(theta));
Ynm = Ytemp(order+1)*exp(1i*order*phi);

% - generally take the real part...

yy = yy.*cos(order*phi);

r = 1*yy/max(max(abs(yy)));     %scale

% Apply spherical coordinate equations

%x = 1.*cos(phi).*sin(theta);    % spherical coordinate equations
%y = 1.*sin(phi).*sin(theta);
%z = 1.*cos(theta);
x = abs(r).*cos(phi).*sin(theta);    % spherical coordinate equations
y = abs(r).*sin(phi).*sin(theta);
z = abs(r).*cos(theta);

C = (r).*ones(size(phi));

h = figure(1);
% Plot the surface
clf
surf(x,y,z,C);
%light
%lighting phong
grid on;
view(-30,30)
%axis tight equal off
%camzoom(1.2)


%for n = 1:20
%    surf(x,y,z,C);
%    view(n*360/20,0);
%    axis tight equal off
%    camzoom(1.0)
%    pause(0.1);
%    F(n) = getframe(gcf);
%    %figure(2)
%    %image(frame2im(F(n)));
%    %test = 0;
%end

%figure(2)
%movie(F,1,2);
   

