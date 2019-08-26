%=========================================================
% 
%=========================================================

function [default] = qMTMapTest_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    calcpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\qMT Mapping\'];
elseif strcmp(filesep,'/')
end
calcfunc = 'qMTmap_v1a';
addpath([calcpath,calcfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Test_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Calcfunc';
default{m,1}.entrystr = calcfunc;
default{m,1}.searchpath = calcpath;
default{m,1}.path = [calcpath,calcfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Calc';
default{m,1}.labelstr = 'Calc';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';