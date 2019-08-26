%====================================================
%
%====================================================

function [default] = Align2Images_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    algnpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Registration\Alignment\'];
elseif strcmp(filesep,'/')
end
algnfunc = 'AlignImages_v1a';
addpath([algnpath,algnfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Registr_Name';
default{m,1}.entrystr = '';

for m = m+1:m+2
    default{m,1}.entrytype = 'RunExtFunc';
    default{m,1}.labelstr = ['Image_File',num2str(m-1)];
    default{m,1}.entrystr = '';
    default{m,1}.buttonname = 'Load';
    default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
    default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
    default{m,1}.(default{m,1}.runfunc1).loadpanel = 'No';
    default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
    default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
    default{m,1}.(default{m,1}.runfunc2).loadpanel = 'No';
    default{m,1}.searchpath = SCRPTPATHS.rootloc;
    default{m,1}.path = SCRPTPATHS.rootloc;
end

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Alignfunc';
default{m,1}.entrystr = algnfunc;
default{m,1}.searchpath = algnpath;
default{m,1}.path = [algnpath,algnfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Align';
default{m,1}.labelstr = 'Align';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

