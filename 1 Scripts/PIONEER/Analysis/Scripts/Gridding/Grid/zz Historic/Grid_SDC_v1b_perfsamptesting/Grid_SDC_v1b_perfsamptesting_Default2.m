%=========================================================
% 
%=========================================================

function [default] = Grid_SDC_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    PlotPath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Grid\Plot\'];
    KernLoadPath = [SCRPTPATHS.scrptshareloc,'2 Convolution\Selectable Functions\Convolution Kernel Select\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(KernLoadPath));
addpath(genpath(PlotPath));

subsamp = '1';
KernLoadfunc = 'LoadKaiserKern_v1a';
Plotfunc = 'Plot_GriddedProfile';

m = 1;
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