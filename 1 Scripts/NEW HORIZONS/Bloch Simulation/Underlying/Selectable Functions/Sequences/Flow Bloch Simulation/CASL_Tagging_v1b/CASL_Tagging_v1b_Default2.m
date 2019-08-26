%=========================================================
% 
%=========================================================

function [default] = CASL_Tagging_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    simpath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\zz Underlying\Selectable Functions\Bloch Equations\'];
elseif strcmp(filesep,'/')
end
simfunc = 'StandardBloch_v1a';
addpath([simpath,simfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RF (deg/ms)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Grad (mT/m)';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExciteWid (m)';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Simfunc';
default{m,1}.entrystr = simfunc;
default{m,1}.searchpath = simpath;
default{m,1}.path = [simpath,simfunc];

