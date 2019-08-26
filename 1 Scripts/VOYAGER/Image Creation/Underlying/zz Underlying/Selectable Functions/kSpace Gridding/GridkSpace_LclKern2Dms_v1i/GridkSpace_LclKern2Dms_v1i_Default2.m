%=========================================================
% 
%=========================================================

function [default] = GridkSpace_LclKern_v1g_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Kern_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadConvKernCur_v4b';
default{m,1}.(default{m,1}.runfunc1).curloc = 'D:\1 Scripts\zs Shared\zy Convolution Kernels';
default{m,1}.runfunc2 = 'LoadConvKernDef_v4b';
default{m,1}.(default{m,1}.runfunc2).defloc = 'D:\1 Scripts\zs Shared\zy Convolution Kernels';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Precision';
default{m,1}.entrystr = 'Double';
default{m,1}.options = {'Single','Double'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Implement';
default{m,1}.entrystr = 'CUDA';
default{m,1}.options = {'Mex','CUDA'};