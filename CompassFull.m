function CompassFull(opt)

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

if nargin==0
    Setup = 'Full';
elseif nargin==1
    if opt == 1
        Setup = 'Dev';
    end
end

%------------------------------------------
% Run Compass
%------------------------------------------
Compass(SoftwareFolder,Setup)

