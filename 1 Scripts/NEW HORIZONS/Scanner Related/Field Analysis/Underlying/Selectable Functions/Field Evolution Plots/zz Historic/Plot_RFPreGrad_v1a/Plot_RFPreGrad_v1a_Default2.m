%=========================================================
% 
%=========================================================

function [default] = Plot_RFPreGrad_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Colour';
default{m,1}.entrystr = 'k-';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Type';
default{m,1}.entrystr = 'Abs';
default{m,1}.options = {'Percent','Abs'};

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
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot_TF';
default{m,1}.labelstr = 'Plot_TF';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';