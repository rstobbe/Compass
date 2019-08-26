%=========================================================
% 
%=========================================================

function [default] = SimImagingRCOStest_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    kSampPath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\kSpaceSampling'];
    ImagePath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\CreateImage'];
    PlotPath = [SCRPTPATHS.rootloc,'Analysis\Underlying\Selectable Functions\Simulated Imaging\Plot'];
elseif strcmp(filesep,'/')
end
addpath(genpath(PlotPath));
addpath(genpath(ImagePath));
addpath(genpath(kSampPath));

kSampfunc = 'kSpaceSampRCOStest_v1a';
Imagefunc = 'CreateImageRCOStest_v1a';
Plotfunc = 'Plot_Object_v1a';

m = 1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'kSampfunc';
default{m,1}.entrystr = kSampfunc;
default{m,1}.searchpath = kSampPath;

%m = m+1;
%default{m,1}.entrytype = 'UnderFunc';
%default{m,1}.labelstr = 'Cnfdfunc';
%default{m,1}.entrystr = Cnfdfunc;
%default{m,1}.searchpath = CnfdPath;

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




