%====================================================
%
%====================================================

function [default] = Match2Images_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Mat\'];
    matchpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Registration\ReSize\'];
    disppath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Registration\Display\'];    
elseif strcmp(filesep,'/')
end
loadfunc = 'Single3DImagesLoad2_v1a';
matchfunc = 'ReSizeIm2Im_v1a';
dispfunc = 'DisplayRegistration_v1b';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImLoadfunc';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Matchfunc';
default{m,1}.entrystr = matchfunc;
default{m,1}.searchpath = matchpath;
default{m,1}.path = [matchpath,matchfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Dispfunc';
default{m,1}.entrystr = dispfunc;
default{m,1}.searchpath = disppath;
default{m,1}.path = [disppath,dispfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Match';
default{m,1}.labelstr = 'Match';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

