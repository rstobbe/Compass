%=========================================================
% 
%=========================================================

function [default] = GSRA_TPIstandard_v2e_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'GSRA_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = 'D:\I NMR Centre\4.7T\Gradient Step Response\Measured Step Responses\2013';
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = 'D:\I NMR Centre\4.7T\Gradient Step Response\Measured Step Responses\2013';
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;