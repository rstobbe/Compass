function CompassImageAnlz

%------------------------------------------
% Setup Paths
%------------------------------------------
disp('Setup Paths');
SoftwareFolder = pwd;
addpath(genpath(SoftwareFolder));

Setup = 'ImageAnalysis';

%------------------------------------------
% Run Compass
%------------------------------------------
Compass(SoftwareFolder,Setup)

