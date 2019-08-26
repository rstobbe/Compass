%=========================================================
% 
%=========================================================

function [default] = SimImaging_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    kSampPath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging'];
    PlotPath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging'];
elseif strcmp(filesep,'/')
end
addpath(genpath(kSampPath));
addpath(genpath(PlotPath));

kSampfunc = 'kSpaceSampling_v1a';
Plotfunc = 'Plot_Object_v1a';

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'LoadTrajectoryImplementation_v2';
default{m,1}.runfuncinput = {SCRPTPATHS.outloc};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'kSampfunc';
default{m,1}.entrystr = kSampfunc;
default{m,1}.searchpath = kSampPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Plotfunc';
default{m,1}.entrystr = Plotfunc;
default{m,1}.searchpath = PlotPath;




