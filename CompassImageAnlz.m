function CompassImageAnlz

%------------------------------------------
% Setup Paths
%------------------------------------------
disp('Setup Paths');
[SoftwareFolder,file]=fileparts(mfilename('fullpath')); 
addpath(genpath(SoftwareFolder));

Setup = 'ImageAnalysis';

%------------------------------------------
% Run Compass
%------------------------------------------
Compass(SoftwareFolder,Setup)

