%====================================================
%
%====================================================

function [default] = B0map2te_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'B0map_Name';
default{m,1}.entrystr = '';

for m = m+1:m+2
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
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaskVal';
default{m,1}.entrystr = '0.25';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TEdif (ms)';
default{m,1}.entrystr = '0.5';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Output';
default{m,1}.entrystr = 'Hz';
default{m,1}.options = {'Hz','mT','PhaseDif','Phase1','Phase2'};

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'B0map';
default{m,1}.labelstr = 'B0map';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

