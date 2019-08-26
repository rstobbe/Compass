%=========================================================
% 
%=========================================================

function [default] = DisplayShimCal_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    plotpath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Overlay Plot\'];
elseif strcmp(filesep,'/')
end
plotfunc = 'PlotMontageOverlayStandard_v1a';
addpath([plotpath,plotfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Plotfunc';
default{m,1}.entrystr = plotfunc;
default{m,1}.searchpath = plotpath;
default{m,1}.path = [plotpath,plotfunc];