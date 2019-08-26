%====================================================
%  
%====================================================

function [IMG,err] = CreateImageNonRWSUI_v1b_Func(INPUT,IMG)

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
inds = strfind(IMG.optionfunc,'\');
path = IMG.optionfunc(1:inds(end));
addpath(genpath(path));
file = IMG.optionfunc(inds(end)+1:length(IMG.optionfunc)-2);
func = str2func(file);  
options = func();

%----------------------------------------------
% Run Recon
%----------------------------------------------
inds = strfind(IMG.execfunc,'\');
path = IMG.execfunc(1:inds(end));
addpath(genpath(path));
file = IMG.execfunc(inds(end)+1:length(IMG.execfunc)-2);
func = str2func(file);  
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

