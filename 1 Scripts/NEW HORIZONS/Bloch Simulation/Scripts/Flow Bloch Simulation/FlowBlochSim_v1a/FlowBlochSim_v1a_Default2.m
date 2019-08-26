%=========================================================
% 
%=========================================================

function [default] = FlowBlochSim_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    seqsimpath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\Selectable Functions\Sequences\Flow Bloch Simulation\'];
elseif strcmp(filesep,'/')
end
seqsimfunc = 'CASL_Tagging_v1b';
addpath([seqsimpath,seqsimfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Sim_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T1 (ms)';
default{m,1}.entrystr = '4500';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T2 (ms)';
default{m,1}.entrystr = '2000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FlowRate (m/s)';
default{m,1}.entrystr = '0.35';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SeqSimfunc';
default{m,1}.entrystr = seqsimfunc;
default{m,1}.searchpath = seqsimpath;
default{m,1}.path = [seqsimpath,seqsimfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Run';
default{m,1}.labelstr = 'Run';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
