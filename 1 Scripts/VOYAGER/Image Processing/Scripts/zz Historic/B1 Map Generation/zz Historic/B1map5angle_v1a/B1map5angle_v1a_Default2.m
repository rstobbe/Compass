%====================================================
%
%====================================================

function [default] = B1map5angle_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'B1map_Name';
default{m,1}.entrystr = '';

for m = m+1:m+6
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

n = 1;
for m = m+1:m+6
    default{m,1}.entrytype = 'Input';
    default{m,1}.labelstr = ['SpecFlip',num2str(n)];
    default{m,1}.entrystr = '';
    n = n+1;
end

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'B1map';
default{m,1}.labelstr = 'B1map';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

