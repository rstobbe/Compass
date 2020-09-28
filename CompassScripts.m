function CompassScripts

%------------------------------------------
% Setup Paths
%------------------------------------------
disp('Setup Paths');
SoftwareFolder = pwd;

ind = strfind(SoftwareFolder,'\');
if(not(strcmp(SoftwareFolder(ind(end)+1:end),'Compass')))
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

