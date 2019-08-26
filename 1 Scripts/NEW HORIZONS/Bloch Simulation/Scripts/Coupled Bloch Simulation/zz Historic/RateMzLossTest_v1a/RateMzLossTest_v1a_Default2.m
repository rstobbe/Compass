%=========================================================
% 
%=========================================================

function [default] = RateMzLossBound_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    ratelosspath = [SCRPTPATHS.newhorizonsloc,'\NMR Simulation\MT\Underlying\Selectable Functions\Rate of Mz Loss Functions\'];
elseif strcmp(filesep,'/')
end
ratelossfunc = 'RateMzLossBound_SupLor_v1a';
addpath([ratelosspath,ratelossfunc]);

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Sim_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RateLossfunc';
default{m,1}.entrystr = ratelossfunc;
default{m,1}.searchpath = ratelosspath;
default{m,1}.path = [ratelosspath,ratelossfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Run';
default{m,1}.labelstr = 'Run';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';