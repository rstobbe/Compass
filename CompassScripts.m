function CompassScripts

%------------------------------------------
% Setup Paths
%------------------------------------------
disp('Setup Paths');
SoftwareFolder = pwd;

file = [SoftwareFolder,'\',mfilename,'.m'];
if(not(isfile(file)))
    disp('Navigate to Compass folder');
    disp('Exiting');
    return
end
addpath(genpath(SoftwareFolder));

Setup = 'Scripts';

%------------------------------------------
% Run Compass
%------------------------------------------
Compass(SoftwareFolder,Setup)

