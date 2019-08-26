%=========================================================
% 
%=========================================================

function [default] = WriteParamEccV_v1d_Default2(SCRPTPATHS)

rstobbeloc = 'X:\sodium\vnmrsys\acqlib\';

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'ParamDefLoc';
default{m,1}.entrystr = rstobbeloc;
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectDirCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = rstobbeloc;
default{m,1}.runfunc2 = 'SelectDirDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = rstobbeloc;
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

