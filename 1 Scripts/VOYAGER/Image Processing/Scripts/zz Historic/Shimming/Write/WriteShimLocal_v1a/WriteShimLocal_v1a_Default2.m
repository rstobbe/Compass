%=========================================================
% 
%=========================================================

function [default] = WriteShimLocal_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    writepath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\B0 Shimming\Writing\'];
elseif strcmp(filesep,'/')
end
writefunc = 'WriteShimV_v1a';
addpath([writepath,writefunc]);

m = 1;
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