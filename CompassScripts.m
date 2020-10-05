function CompassScripts

%------------------------------------------
% Setup Paths
%------------------------------------------
disp('Setup Paths');
[SoftwareFolder,file]=fileparts(mfilename('fullpath')); 
addpath(genpath(SoftwareFolder));

Setup = 'Scripts';

%------------------------------------------
% Run Compass
%------------------------------------------
Compass(SoftwareFolder,Setup)

