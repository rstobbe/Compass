%=========================================================
% 
%=========================================================

function [default] = SimImaging_v2b_perfsamptest_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    kSampPath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\kSpaceSampling'];
    NoiseAddPath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\NoiseAdd'];
    ImagePath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\CreateImage'];
    PlotPath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\Plot'];
elseif strcmp(filesep,'/')
end
addpath(genpath(PlotPath));
addpath(genpath(ImagePath));
addpath(genpath(NoiseAddPath));
addpath(genpath(kSampPath));

kSampfunc = 'kSpaceSampling_v2a_testing';
Imagefunc = 'CreateImage_v1b_testing';
NoiseAddfunc = 'NoiseAdd_v1a';
Plotfunc = 'Plot_Image_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'kSampfunc';
default{m,1}.entrystr = kSampfunc;
default{m,1}.searchpath = kSampPath;

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'NoiseAddfunc';
default{m,1}.entrystr = NoiseAddfunc;
default{m,1}.searchpath = NoiseAddPath;

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'Imagefunc';
default{m,1}.entrystr = Imagefunc;
default{m,1}.searchpath = ImagePath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Plotfunc';
default{m,1}.entrystr = Plotfunc;
default{m,1}.searchpath = PlotPath;




