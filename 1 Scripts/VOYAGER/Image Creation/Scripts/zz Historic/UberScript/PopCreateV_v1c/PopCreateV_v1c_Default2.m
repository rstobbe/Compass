%====================================================
%
%====================================================

function [default] = PopCreateV_v1c_Default2(SCRPTPATHS)

global USERGBL

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'VarianFolder';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectVarianDirCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = '';
default{m,1}.runfunc2 = 'SelectVarianDirDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = USERGBL.varianloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'LocalFolder';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectDataDirCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = '';
default{m,1}.runfunc2 = 'SelectDataDirDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = USERGBL.experimentsloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Function';
default{m,1}.entrystr = 'PopOnly';
default{m,1}.options = {'PopOnly','PopCreate'};

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Image';
default{m,1}.labelstr = 'Create Image';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

