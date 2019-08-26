%=========================================================
% 
%=========================================================

function [default] = MTsimulation_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    seqsimpath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\Selectable Functions\Sequences for Simulation\'];
elseif strcmp(filesep,'/')
end
seqsimfunc = 'SeqSimSPGR_v1a';
addpath([seqsimpath,seqsimfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Sim_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'relM0B (F)';
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
