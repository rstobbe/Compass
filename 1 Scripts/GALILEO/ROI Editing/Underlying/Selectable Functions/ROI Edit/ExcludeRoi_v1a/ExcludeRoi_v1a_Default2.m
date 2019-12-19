%=========================================================
% 
%=========================================================

function [default] = ExcludeRoi_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Roi_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectMatFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'SelectMatFileDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
