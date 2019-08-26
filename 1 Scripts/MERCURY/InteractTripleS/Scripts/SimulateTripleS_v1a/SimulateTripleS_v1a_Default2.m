%=========================================================
% 
%=========================================================

function [default] = SimulateTripleS_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    simpath = [SCRPTPATHS.mercuryloc,'InteractTripleS\Underlying\Selectable Functions\Simulation\'];
    plotpath = [SCRPTPATHS.mercuryloc,'InteractTripleS\Underlying\Selectable Functions\Simulation\'];
    outputpath = [SCRPTPATHS.mercuryloc,'InteractTripleS\Underlying\Selectable Functions\Output\'];
elseif strcmp(filesep,'/')
end
simfunc = 'Simulate_ModelMxy_v1a';
plotfunc = 'Plot_SimStandard_v1a';
outputfunc = 'Output_Dummy_v1a';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Study_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Simulatefunc';
default{m,1}.entrystr = simfunc;
default{m,1}.searchpath = simpath;
default{m,1}.path = [simpath,simfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Plotfunc';
default{m,1}.entrystr = plotfunc;
default{m,1}.searchpath = plotpath;
default{m,1}.path = [plotpath,plotfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Outputfunc';
default{m,1}.entrystr = outputfunc;
default{m,1}.searchpath = outputpath;
default{m,1}.path = [outputpath,outputfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'sim';
default{m,1}.labelstr = 'Sim';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
