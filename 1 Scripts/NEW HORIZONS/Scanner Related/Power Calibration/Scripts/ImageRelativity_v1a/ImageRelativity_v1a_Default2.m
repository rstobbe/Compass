%====================================================
%
%====================================================

function [default] = ImageRelativity_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'RelImage_Name';
default{m,1}.entrystr = '';

for m = 2:3
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
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'RelImage';
default{m,1}.labelstr = 'RelImage';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

