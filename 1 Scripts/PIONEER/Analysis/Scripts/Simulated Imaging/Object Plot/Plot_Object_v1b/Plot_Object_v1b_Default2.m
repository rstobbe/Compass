%=========================================================
% 
%=========================================================

function [default] = Plot_Object_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    objectpath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\kSpace Sample\Object Functions\Numerical\'];    
elseif strcmp(filesep,'/')
end
objectfunc = 'SimHead1CalFov250_v1a';
addpath([objectpath,objectfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Objectfunc';
default{m,1}.entrystr = objectfunc;
default{m,1}.searchpath = objectpath;
default{m,1}.path = [objectpath,objectfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'PlotObject';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';
