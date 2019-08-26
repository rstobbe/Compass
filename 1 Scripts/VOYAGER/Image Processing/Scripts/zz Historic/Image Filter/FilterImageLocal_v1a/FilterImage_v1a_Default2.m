%=========================================================
% 
%=========================================================

function [default] = FilterImage_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    filtpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Filter Image\'];
elseif strcmp(filesep,'/')
end
filtfunc = 'FilterImageKaiser_v1a';
addpath([filtpath,filtfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Image_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Filtfunc';
default{m,1}.entrystr = filtfunc;
default{m,1}.searchpath = filtpath;
default{m,1}.path = [filtpath,filtfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Filter';
default{m,1}.labelstr = 'Filter';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';