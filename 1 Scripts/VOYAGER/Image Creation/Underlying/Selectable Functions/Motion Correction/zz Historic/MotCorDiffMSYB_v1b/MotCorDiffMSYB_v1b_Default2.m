%=========================================================
% 
%=========================================================

function [default] = MotCorDiffMSYB_v1b_Default2(SCRPTPATHS)

SCRPTPATHS.Vrootloc = 'D:\1 Scripts\VOYAGER\Set 1.1\';
if strcmp(filesep,'\')
    gridpath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\kSpace Gridding\'];    
    imagepath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\Selectable Functions\Image Creation Via Gridding\']; 
    motioncorpath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Motion Correction\'];   
elseif strcmp(filesep,'/')
end
gridfunc = 'GridkSpace_SubSampSel_v1a';
imagefunc = 'ImageViaGriddingStandard_v1a';
rotcorfunc = 'RotCorMSYB_v1a';
transcorfunc = 'TransCorMSYB_v1a';
kshftcorfunc = 'kShiftCorMSYB_v1a';
addpath([gridpath,gridfunc]);
addpath([imagepath,imagefunc]);
addpath([motioncorpath,rotcorfunc]);
addpath([motioncorpath,transcorfunc]);
addpath([motioncorpath,kshftcorfunc]);

trajmax = '4.5';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrajMax (kstps)';
default{m,1}.entrystr = trajmax;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Gridfunc';
default{m,1}.entrystr = gridfunc;
default{m,1}.searchpath = gridpath;
default{m,1}.path = [gridpath,gridfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'kShftCorfunc';
default{m,1}.entrystr = kshftcorfunc;
default{m,1}.searchpath = motioncorpath;
default{m,1}.path = [motioncorpath,kshftcorfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TransCorfunc';
default{m,1}.entrystr = transcorfunc;
default{m,1}.searchpath = motioncorpath;
default{m,1}.path = [motioncorpath,transcorfunc];

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
default{m,1}.searchpath = motioncorpath;
default{m,1}.path = [motioncorpath,rotcorfunc];





