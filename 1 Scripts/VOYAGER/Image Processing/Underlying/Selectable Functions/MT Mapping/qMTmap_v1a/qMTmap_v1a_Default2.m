%====================================================
%
%====================================================

function [default] = qMTmap_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    simpath = [SCRPTPATHS.newhorizonsloc,'Bloch Simulation\Underlying\zz Underlying\Selectable Functions\MT Functions\MT DE Simulation\'];
elseif strcmp(filesep,'/')
end
simfunc = 'MTdesimSPGR_v1a';
addpath([simpath,simfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Simfunc';
default{m,1}.entrystr = simfunc;
default{m,1}.searchpath = simpath;
default{m,1}.path = [simpath,simfunc];




