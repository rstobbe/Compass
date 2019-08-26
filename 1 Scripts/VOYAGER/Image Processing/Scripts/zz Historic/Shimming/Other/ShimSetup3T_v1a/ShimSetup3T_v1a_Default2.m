%=========================================================
% 
%=========================================================

function [default] = ShimSetup3T_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Image_File1';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadImageCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.experimentsloc;
default{m,1}.runfunc2 = 'LoadImageDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.experimentsloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Image_File2';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadImageCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.experimentsloc;
default{m,1}.runfunc2 = 'LoadImageDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.experimentsloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Shim_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectGeneralFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.experimentsloc;
default{m,1}.runfunc2 = 'SelectGeneralFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.experimentsloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Setup';
default{m,1}.labelstr = 'Setup';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';