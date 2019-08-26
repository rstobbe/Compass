%=========================================================
% 
%=========================================================

function [default] = mN06a_v1_Default(~)

global SDCROUTLOC
addpath(genpath(SDCROUTLOC));
DOVPath = [SDCROUTLOC,'SDC Functions\Common SDC Specific Routines\DOV Functions\'];
FindPath = [SDCROUTLOC,'SDC Functions\Common SDC Specific Routines\Neighbor Convolution\Find Neighbour Functions\'];
KernValPath = [SDCROUTLOC,'SDC Functions\Common SDC Specific Routines\Neighbor Convolution\KernVal Functions\'];
ConvPath = [SDCROUTLOC,'SDC Functions\Common SDC Specific Routines\Neighbor Convolution\Convolve Functions\'];
AccPath = [SDCROUTLOC,'SDC Functions\Common SDC Specific Routines\Acceleration Functions\'];
AnlzPath = [SDCROUTLOC,'SDC Functions\Common SDC Specific Routines\Analysis Functions\'];
BreakPath = [SDCROUTLOC,'SDC Functions\Common SDC Specific Routines\Break Functions\'];

m = 1;
default{m,1}.labelstyle = '0labellvl2'; 
default{m,1}.labelstr = 'DOVFunc';
default{m,1}.entrystr = 'DOVN_v1';
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = DOVPath;
default{m,1}.buttonname = 'Select';
default{m,1}.entrytype = 'Function';
default{m,1}.funcname = '';

m = m+1;
default{m,1}.labelstyle = '0labellvl2'; 
default{m,1}.labelstr = 'FindFunc';
default{m,1}.entrystr = 'mFindNghbrsCUDA_v1f';
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = FindPath;
default{m,1}.buttonname = 'Select';
default{m,1}.entrytype = 'Function';
default{m,1}.funcname = '';

m = m+1;
default{m,1}.labelstyle = '0labellvl2'; 
default{m,1}.labelstr = 'KernValFunc';
default{m,1}.entrystr = 'SlvNghKrnVals_v3a';
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = KernValPath;
default{m,1}.buttonname = 'Select';
default{m,1}.entrytype = 'Function';
default{m,1}.funcname = '';

m = m+1;
default{m,1}.labelstyle = '0labellvl2'; 
default{m,1}.labelstr = 'ConvFunc';
default{m,1}.entrystr = 'ConvNghbrs_v3a';
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = ConvPath;
default{m,1}.buttonname = 'Select';
default{m,1}.entrytype = 'Function';
default{m,1}.funcname = '';

m = m+1;
default{m,1}.labelstyle = '0labellvl2'; 
default{m,1}.labelstr = 'AccFunc';
default{m,1}.entrystr = 'AccSelect_v1';
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = AccPath;
default{m,1}.buttonname = 'Select';
default{m,1}.entrytype = 'Function';
default{m,1}.funcname = '';

m = m+1;
default{m,1}.labelstyle = '0labellvl2'; 
default{m,1}.labelstr = 'AnlzFunc';
default{m,1}.entrystr = 'GrdConvTst_v1';
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = AnlzPath;
default{m,1}.buttonname = 'Select';
default{m,1}.entrytype = 'Function';
default{m,1}.funcname = '';

m = m+1;
default{m,1}.labelstyle = '0labellvl2'; 
default{m,1}.labelstr = 'BreakFunc';
default{m,1}.entrystr = 'Iterations_v1';
default{m,1}.entryvalue = 0;
default{m,1}.searchpath = BreakPath;
default{m,1}.buttonname = 'Select';
default{m,1}.entrytype = 'Function';
default{m,1}.funcname = '';

