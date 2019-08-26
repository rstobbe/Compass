%====================================================
%
%====================================================

function [default] = FolderCreate_v1c_Default2(SCRPTPATHS)

global USERGBL

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Folder';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectDirCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.loc;
default{m,1}.runfunc2 = 'SelectDirDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = USERGBL.experimentsloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Image';
default{m,1}.labelstr = 'Create Image';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

