%=========================================================
% 
%=========================================================

function [default] = TopMTsimSPGR_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    simpath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\zz Underlying\Selectable Functions\MT Functions\MT DE Simulation\'];
elseif strcmp(filesep,'/')
end
simfunc = 'MTsimSPGRde_v1a';
addpath([simpath,simfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SatRF_FA (deg)';
default{m,1}.entrystr = '800';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SatRF_woff (Hz)';
default{m,1}.entrystr = '1000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SatRF_tau (ms)';
default{m,1}.entrystr = '15';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExRF_FA (deg)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExRF_woff (Hz)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExRF_tau (ms)';
default{m,1}.entrystr = '0.05';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TR (ms)';
default{m,1}.entrystr = '50';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TE (ms)';
default{m,1}.entrystr = '2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'NSteady';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SatPulseN';
default{m,1}.entrystr = '150';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExPulseN';
default{m,1}.entrystr = '3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RecN';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'RecordSS';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'No','Yes'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'MTsimSPGRfunc';
default{m,1}.entrystr = simfunc;
default{m,1}.searchpath = simpath;
default{m,1}.path = [simpath,simfunc];

