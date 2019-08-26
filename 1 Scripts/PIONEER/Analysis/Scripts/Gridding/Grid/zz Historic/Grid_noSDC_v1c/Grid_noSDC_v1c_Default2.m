%=========================================================
% 
%=========================================================

function [default] = Grid_noSDC_v1c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    PlotPath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Grid\Plot\'];
    KernLoadPath = [SCRPTPATHS.scrptshareloc,'2 Convolution\Selectable Functions\KernLoad Functions\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(KernLoadPath));
addpath(genpath(PlotPath));

subsamp = '1';
KernLoadfunc = 'KernLoad_v1a';
Plotfunc = 'Plot_GriddedSlices_v1b';

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'LoadTrajectoryImplementation_v3';
default{m,1}.runfuncinput = {SCRPTPATHS.outloc};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SubSamp';
default{m,1}.entrystr = subsamp;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'KernLoadfunc';
default{m,1}.entrystr = KernLoadfunc;
default{m,1}.searchpath = KernLoadPath;

m = m+1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Ksz';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Plotfunc';
default{m,1}.entrystr = Plotfunc;
default{m,1}.searchpath = PlotPath;