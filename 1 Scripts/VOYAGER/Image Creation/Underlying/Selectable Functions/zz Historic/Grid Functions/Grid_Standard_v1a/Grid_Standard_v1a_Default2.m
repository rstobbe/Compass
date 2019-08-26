%====================================================
%
%====================================================

function [default] = Grid_Standard_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    kernpath = 'D:\1 Scripts\zs Shared\zy Convolution Kernels\';
    invfiltpath = 'D:\1 Scripts\zs Shared\zx Inversion Filters\';
elseif strcmp(filesep,'/')
end
addpath(genpath(kernpath));

m = 1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'ConvKernPath';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc = 'SelectDirectory_v2';
default{m,1}.runfuncinput = {kernpath};
default{m,1}.runfuncoutput = {};

m = m+1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'InvFiltPath';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc = 'SelectDirectory_v2';
default{m,1}.runfuncinput = {invfiltpath};
default{m,1}.runfuncoutput = {};
