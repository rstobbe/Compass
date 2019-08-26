%=========================================================
% 
%=========================================================

function [default] = TPI_GSRAstandard_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'GSRA_Data';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'LoadMatFile_v3';
default{m,1}.runfuncinput = {'D:\I NMR Centre\4.7T\Gradient Step Response\Measured Step Responses\Apr2009'};
default{m,1}.runfuncoutput = {''};
