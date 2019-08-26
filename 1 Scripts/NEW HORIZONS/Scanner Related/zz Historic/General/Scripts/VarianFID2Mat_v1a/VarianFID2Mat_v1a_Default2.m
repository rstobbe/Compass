%====================================================
%
%====================================================

function [default] = VarianFID2Mat_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'System';
default{m,1}.entrystr = 'Varian';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'FIDpath';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectFidDataCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.loc;
default{m,1}.runfunc2 = 'SelectFidDataDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.loc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Export';
default{m,1}.labelstr = 'Export FID';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

