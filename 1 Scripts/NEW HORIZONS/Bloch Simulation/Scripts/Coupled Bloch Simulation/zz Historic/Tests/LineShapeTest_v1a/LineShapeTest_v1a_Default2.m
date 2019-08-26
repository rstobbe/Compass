%=========================================================
% 
%=========================================================

function [default] = LineShapeTest_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    linevalpath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\Selectable Functions\MT Functions\Line Shape Values at Woff\'];
elseif strcmp(filesep,'/')
end
linevalfunc = 'SupLorAtWoff_v1a';
addpath([linevalpath,linevalfunc]);

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Sim_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T2 (ms)';
default{m,1}.entrystr = '0.01';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'LineShapeValfunc';
default{m,1}.entrystr = linevalfunc;
default{m,1}.searchpath = linevalpath;
default{m,1}.path = [linevalpath,linevalfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Run';
default{m,1}.labelstr = 'Run';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
