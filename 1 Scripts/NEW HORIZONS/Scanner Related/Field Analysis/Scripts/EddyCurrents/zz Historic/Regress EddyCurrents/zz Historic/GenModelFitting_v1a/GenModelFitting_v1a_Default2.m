%=========================================================
% 
%=========================================================

function [default] = GenModelFitting_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Rgrs_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'GradDes_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GStartShift (ms)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Regression';
default{m,1}.labelstr = 'Regression';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

