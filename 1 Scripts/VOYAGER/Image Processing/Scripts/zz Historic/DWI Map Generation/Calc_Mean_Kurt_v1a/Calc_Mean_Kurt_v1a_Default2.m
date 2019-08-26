%=========================================================
% 
%=========================================================

function [default] = Calc_Mean_Kurt_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    calcpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Calculate Mean Kurtosis\'];
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Diffusion\'];
elseif strcmp(filesep,'/')
end
calcfunc = 'Calc2KurtIM_v1d';
loadfunc = 'LoadDiffImNiftiAveB0_v1a';
addpath([calcpath,calcfunc]);
addpath([loadpath,loadfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Loadfunc';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Calcfunc';
default{m,1}.entrystr = calcfunc;
default{m,1}.searchpath = calcpath;
default{m,1}.path = [calcpath,calcfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'CalcKurt';
default{m,1}.labelstr = 'CalcKurt';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';




