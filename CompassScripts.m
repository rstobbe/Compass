function CompassScripts

%------------------------------------------
% Setup Paths
%------------------------------------------
disp('Setup Paths');
SoftwareFolder = pwd;
addpath(genpath(SoftwareFolder));

Setup = 'Scripts';

%------------------------------------------
% Run Compass
%------------------------------------------
Compass(SoftwareFolder,Setup)

