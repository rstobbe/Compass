%=========================================================
% 
%=========================================================

function [default] = StabilityCheckMovie_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    maskpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Masking\'];
    filtpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Filter Image\'];
elseif strcmp(filesep,'/')
end
filtfunc = 'FilterImageKaiser2D_v1a';
addpath([filtpath,filtfunc]);
maskfunc = 'IntenseMask_v1a';
addpath([maskpath,maskfunc]);

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Type';
default{m,1}.entrystr = 'Abs';
default{m,1}.options = {'Abs','Phase','Real','Imag'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Images (a:b)';
default{m,1}.entrystr = '3:102';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SliceNum';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Filtfunc';
default{m,1}.entrystr = filtfunc;
default{m,1}.searchpath = filtpath;
default{m,1}.path = [filtpath,filtfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Maskfunc';
default{m,1}.entrystr = maskfunc;
default{m,1}.searchpath = maskpath;
default{m,1}.path = [maskpath,maskfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Test';
default{m,1}.labelstr = 'Test';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';