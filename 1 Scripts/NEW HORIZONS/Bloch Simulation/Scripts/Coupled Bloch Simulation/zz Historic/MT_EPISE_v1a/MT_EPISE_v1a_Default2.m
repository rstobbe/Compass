%=========================================================
% 
%=========================================================

function [default] = MT_2DEPI_v1a_Default2(SCRPTPATHS)

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
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Sim_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'relM0B';
default{m,1}.entrystr = '0.012';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T1A (ms)';
default{m,1}.entrystr = '1250';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T1B (ms)';
default{m,1}.entrystr = '1000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T2A (ms)';
default{m,1}.entrystr = '38';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T2B (ms)';
default{m,1}.entrystr = '0.0127';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExchgRate (1/ms)';
default{m,1}.entrystr = '0.176';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SatRF_effFA (deg)';
default{m,1}.entrystr = '180';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SatRF_woff (Hz)';
default{m,1}.entrystr = '1000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SatRF_tau (ms)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SatRF_rep (ms)';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TR (ms)';
default{m,1}.entrystr = '6000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TE (ms)';
default{m,1}.entrystr = '30';

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
