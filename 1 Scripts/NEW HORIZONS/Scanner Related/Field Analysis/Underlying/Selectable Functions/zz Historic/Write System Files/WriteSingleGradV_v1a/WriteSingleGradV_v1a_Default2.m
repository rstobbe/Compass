%====================================================
%
%====================================================

function [default] = WriteSingleGradV_v1a_Default2(SCRPTPATHS)

rstobbeloc = 'X:\sodium\vnmrsys\shapelib\';

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'GradDefLoc';
default{m,1}.entrystr = rstobbeloc;
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectDirCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = rstobbeloc;
default{m,1}.runfunc2 = 'SelectDirDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = rstobbeloc;
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'sysGmax (mT/m)';
default{m,1}.entrystr = '59.7';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'WriteGrads';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};