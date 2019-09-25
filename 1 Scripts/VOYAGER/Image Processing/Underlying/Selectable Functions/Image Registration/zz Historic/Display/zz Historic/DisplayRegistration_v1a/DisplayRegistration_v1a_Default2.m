%=========================================================
% 
%=========================================================

function [default] = DisplayRegistration_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    plotpath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\Selectable Functions\Figure Creation\'];
elseif strcmp(filesep,'/')
end
plotfunc = 'MontageOverlayFigure_v1a';
addpath([plotpath,plotfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Mapfunc';
default{m,1}.entrystr = plotfunc;
default{m,1}.searchpath = plotpath;
default{m,1}.path = [plotpath,plotfunc];



