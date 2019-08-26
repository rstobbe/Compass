%=========================================================
% 
%=========================================================

function [default] = RotTransCorOnlyMSYB_v1a_Default2(SCRPTPATHS)

SCRPTPATHS.Vrootloc = 'D:\1 Scripts\VOYAGER\Set 1.1\';
if strcmp(filesep,'\')
    imagepath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\Selectable Functions\Image Creation Via Gridding\'];    
    rotcorpath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Motion Correction\'];   
elseif strcmp(filesep,'/')
end
imagefunc = 'ImageViaGriddingStandard_v1a';
rotcorfunc = 'RotTransCorMSYB_v1a';
addpath([imagepath,imagefunc]);
addpath([rotcorpath,rotcorfunc]);

trajmax = '4.5';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrajMax (kstps)';
default{m,1}.entrystr = trajmax;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Imagefunc';
default{m,1}.entrystr = imagefunc;
default{m,1}.searchpath = imagepath;
default{m,1}.path = [imagepath,imagefunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RotCorfunc';
default{m,1}.entrystr = rotcorfunc;
default{m,1}.searchpath = rotcorpath;
default{m,1}.path = [rotcorpath,rotcorfunc];

