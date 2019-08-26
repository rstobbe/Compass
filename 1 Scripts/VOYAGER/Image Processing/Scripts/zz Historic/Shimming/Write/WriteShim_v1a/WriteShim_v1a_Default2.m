%=========================================================
% 
%=========================================================

function [default] = WriteShim_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    writepath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\B0 Shimming\Writing\'];
elseif strcmp(filesep,'/')
end
writefunc = 'WriteShimV_v1a';
addpath([writepath,writefunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Write_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Shim_File';
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
default{m,1}.labelstr = 'Writefunc';
default{m,1}.entrystr = writefunc;
default{m,1}.searchpath = writepath;
default{m,1}.path = [writepath,writefunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Write';
default{m,1}.labelstr = 'Write';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';