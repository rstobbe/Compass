%=========================================================
% 
%=========================================================

function [default] = RotCorMSYB_v2a_Default2(SCRPTPATHS)

SCRPTPATHS.Vrootloc = 'D:\1 Scripts\VOYAGER\Set 1.1\';
if strcmp(filesep,'\')
    imagepath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\Selectable Functions\Image Creation Via Gridding\'];    
    obshftcorregpath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Motion Correction Regression\'];   
elseif strcmp(filesep,'/')
end
imagefunc = 'ImageViaGriddingStandard_v1a';
obshftcorregfunc = 'RotCorReg_v2a';
addpath([imagepath,imagefunc]);
addpath([obshftcorregpath,obshftcorregfunc]);

trajmax = '4.5';
relthresh = '0.2';
rottol = '0.01';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrajMax (kstps)';
default{m,1}.entrystr = trajmax;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelThresh';
default{m,1}.entrystr = relthresh;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RotTol (deg)';
default{m,1}.entrystr = rottol;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RotCorRegfunc';
default{m,1}.entrystr = obshftcorregfunc;
default{m,1}.searchpath = obshftcorregpath;
default{m,1}.path = [obshftcorregpath,obshftcorregfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Imagefunc';
default{m,1}.entrystr = imagefunc;
default{m,1}.searchpath = imagepath;
default{m,1}.path = [imagepath,imagefunc];