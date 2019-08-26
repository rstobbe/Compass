%======================================================
% (v1a)
%
%======================================================

function PlotSphHarm_v1a

% Create the grid
delta = pi/40;
theta = 0 : delta : pi; % altitude
phi = 0 : 2*delta : 2*pi; % azimuth
[phi,theta] = meshgrid(phi,theta);

rank = 3;
order = 1;

GenSphHarm_v1a(rank,order,phi,theta);