%====================================================
%
%====================================================

function [default] = Sim_RFwfm_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    blochpath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\zz Underlying\Selectable Functions\Bloch Equations\'];
elseif strcmp(filesep,'/')
end
blochfunc = 'StandardBloch_v1a';
addpath([blochpath,blochfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Blochfunc';
default{m,1}.entrystr = blochfunc;
default{m,1}.searchpath = blochpath;
default{m,1}.path = [blochpath,blochfunc];

