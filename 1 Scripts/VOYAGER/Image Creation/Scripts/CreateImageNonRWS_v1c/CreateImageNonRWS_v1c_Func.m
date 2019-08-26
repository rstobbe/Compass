%====================================================
%  
%====================================================

function [IMG,err] = CreateImageNonRWS_v1c_Func(INPUT,IMG)

Status('busy','Create Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DIR = INPUT.DIR;
clear INPUT;

%----------------------------------------------
% Import FID
%----------------------------------------------
func = str2func([IMG.selectdatafunc,'_Func']);  
INPUT = struct();
[DIR,err] = func(DIR,INPUT);
if err.flag
    return
end
clear INPUT;
cd(DIR.DataDir);

%----------------------------------------------
% Get Options
%----------------------------------------------
addpath(IMG.Options.path);
func = str2func(IMG.Options.file(1:end-2));  
options = func();

%----------------------------------------------
% Run Recon
%----------------------------------------------
addpath(genpath(IMG.Exec.path));
func = str2func(IMG.Exec.file(1:end-2));  
[IMG.par,IMG.Im] = func(DIR.DataDir,options);
IMG.path = DIR.DataDir;
% don't save image for now...
%IMG = rmfield(IMG,'Im');

%----------------------------------------------
% Panel
%----------------------------------------------
Panel(1,:) = {'','','Output'};
IMG.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%----------------------------------------------
% Return
%----------------------------------------------
Status('done','');
Status2('done','',2);
Status2('done','',3);

