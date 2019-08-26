%=========================================================
% 
%=========================================================

function [default] = DisplayShim_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    plotpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\B0 Shimming\Plotting\'];
elseif strcmp(filesep,'/')
end
plotfunc = 'ShimPlot_v1b';
addpath([plotpath,plotfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Plotfunc';
default{m,1}.entrystr = plotfunc;
default{m,1}.searchpath = plotpath;
default{m,1}.path = [plotpath,plotfunc];

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Orientation';
default{m,1}.entrystr = 'Axial';
default{m,1}.options = {'Sagittal','Coronal','Axial'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Inset (L,R,T,B,I,O)';
default{m,1}.entrystr = '0,0,0,0,0,0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DispOrigFull (Hz)';
default{m,1}.entrystr = 'Full';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DispOrigMask (Hz)';
default{m,1}.entrystr = 'Full';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DispFitMask (Hz)';
default{m,1}.entrystr = 'Full';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Display';
default{m,1}.labelstr = 'Display';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';