%=========================================================
% 
%=========================================================

function [default] = Study_EmbeddedSpheres_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Study_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Data_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectGenericFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.experimentsloc;
default{m,1}.runfunc2 = 'SelectGenericFileDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.experimentsloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'build';
default{m,1}.labelstr = 'Run';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Study';
