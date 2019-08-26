%=========================================================
% 
%=========================================================

function [default] = MTsim_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    coupledblochpath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\Selectable Functions\Bloch Equations\'];
    linevalpath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\Selectable Functions\MT Functions\Line Shape Values at Woff\'];
elseif strcmp(filesep,'/')
end
coupledblochfunc = 'ModifiedCoupledBloch_v1a';
addpath([coupledblochpath,coupledblochfunc]);
linevalfunc = 'SupLorAtWoff_v1a';
addpath([linevalpath,linevalfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Sim_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'relM0B';
default{m,1}.entrystr = '0.10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T1A (ms)';
default{m,1}.entrystr = '1200';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T1B (ms)';
default{m,1}.entrystr = '1000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T2A (ms)';
default{m,1}.entrystr = '40';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T2B (ms)';
default{m,1}.entrystr = '0.01';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExchgRate (1/ms)';
default{m,1}.entrystr = '0.030';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SatRF_effFA (deg)';
default{m,1}.entrystr = '500';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SatRF_woff (Hz)';
default{m,1}.entrystr = '400';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SatRF_tau (ms)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TR (ms)';
default{m,1}.entrystr = '35';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TE (ms)';
default{m,1}.entrystr = '2';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'LineShapeValfunc';
default{m,1}.entrystr = linevalfunc;
default{m,1}.searchpath = linevalpath;
default{m,1}.path = [linevalpath,linevalfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'CoupledBlochfunc';
default{m,1}.entrystr = coupledblochfunc;
default{m,1}.searchpath = coupledblochpath;
default{m,1}.path = [coupledblochpath,coupledblochfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Run';
default{m,1}.labelstr = 'Run';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
