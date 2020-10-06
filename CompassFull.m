function CompassFull(opt)

%------------------------------------------
% Setup Paths
%------------------------------------------
disp('Setup Paths');
[SoftwareFolder,file]=fileparts(mfilename('fullpath')); 
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

