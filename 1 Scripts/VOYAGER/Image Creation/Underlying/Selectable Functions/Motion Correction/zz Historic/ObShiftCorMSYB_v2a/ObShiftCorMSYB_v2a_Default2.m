%=========================================================
% 
%=========================================================

function [default] = ObShiftCorMSYB_v2a_Default2(SCRPTPATHS)

SCRPTPATHS.Vrootloc = 'D:\1 Scripts\VOYAGER\Set 1.1\';
if strcmp(filesep,'\')
    imagepath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\Selectable Functions\Image Creation Via Gridding\'];    
    obshftcorregpath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Motion Correction\Motion Correction Regression\'];   
elseif strcmp(filesep,'/')
end
imagefunc = 'ImageViaGriddingStandard_v1a';
obshftcorregfunc = 'ObShiftReg_v2a';
addpath([imagepath,imagefunc]);
addpath([obshftcorregpath,obshftcorregfunc]);

trajmax = '4.5';
relthresh = '0.2';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrajMax (kstps)';
default{m,1}.entrystr = trajmax;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelThresh';
default{m,1}.entrystr = relthresh;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ObShftRegfunc';
default{m,1}.entrystr = obshftcorregfunc;
default{m,1}.searchpath = obshftcorregpath;
default{m,1}.path = [obshftcorregpath,obshftcorregfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Imagefunc';
default{m,1}.entrystr = imagefunc;
default{m,1}.searchpath = imagepath;
default{m,1}.path = [imagepath,imagefunc];