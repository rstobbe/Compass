%====================================================
%
%====================================================

function [default] = WrtGrad_NFilesMRS_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'GradDefLoc';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectDirCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'SelectDirDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'sysGmaxX (mT/m)';
default{m,1}.entrystr = '22.74';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'sysGmaxY (mT/m)';
default{m,1}.entrystr = '21.94';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'sysGmaxZ (mT/m)';
default{m,1}.entrystr = '22.59';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'WriteGrads';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};