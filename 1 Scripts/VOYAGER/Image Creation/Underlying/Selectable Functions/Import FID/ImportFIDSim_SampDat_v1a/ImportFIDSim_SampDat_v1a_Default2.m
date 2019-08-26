%=========================================================
% 
%=========================================================

function [default] = ImportFIDSim_SampDat_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'SampDat';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadKSampCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadKSampDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
