%=========================================================
% 
%=========================================================

function [default] = MzLossSingleRF_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    blochexcitepath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\Selectable Functions\Bloch Equations\'];
elseif strcmp(filesep,'/')
end
blochexcitefunc = 'Excite_MonoExp_v1a';
addpath([blochexcitepath,blochexcitefunc]);

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Sim_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T1 (ms)';
default{m,1}.entrystr = '1000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T2 (ms)';
default{m,1}.entrystr = '0.01';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'w1 (Hz)';
default{m,1}.entrystr = '200';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'woff (Hz)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'tauRF (ms)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'BlochExcitefunc';
default{m,1}.entrystr = blochexcitefunc;
default{m,1}.searchpath = blochexcitepath;
default{m,1}.path = [blochexcitepath,blochexcitefunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Run';
default{m,1}.labelstr = 'Run';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
