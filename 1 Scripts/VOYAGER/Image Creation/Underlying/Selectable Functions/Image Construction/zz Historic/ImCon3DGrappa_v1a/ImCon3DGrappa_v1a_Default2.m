%=========================================================
% 
%=========================================================

function [default] = ImCon3DGrappa_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    grappakernpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Grappa\Grappa Kernels\'];
    grappacaldatextpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Grappa\Grappa CalDat Extract\'];
    grappawcalcpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Grappa\Grappa Weight Calc\'];
    grappaconvpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Grappa\Grappa Convolution\'];
elseif strcmp(filesep,'/')
end
grappakernfunc = 'GrappaKernCube_v1a';
grappacaldatextfunc = 'GrappaCalDatExtCube_v1a';
grappawcalcfunc = 'GrappaWCalc_v1b';
grappaconvfunc = 'GrappaConv_v1b';
addpath([grappakernpath,grappakernfunc]);
addpath([grappacaldatextpath,grappacaldatextfunc]);
addpath([grappawcalcpath,grappawcalcfunc]);
addpath([grappaconvpath,grappaconvfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GrappaKernfunc';
default{m,1}.entrystr = grappakernfunc;
default{m,1}.searchpath = grappakernpath;
default{m,1}.path = [grappakernpath,grappakernfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GrappaCalDatExtfunc';
default{m,1}.entrystr = grappacaldatextfunc;
default{m,1}.searchpath = grappacaldatextpath;
default{m,1}.path = [grappacaldatextpath,grappacaldatextfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GrappaWCalcfunc';
default{m,1}.entrystr = grappawcalcfunc;
default{m,1}.searchpath = grappawcalcpath;
default{m,1}.path = [grappawcalcpath,grappawcalcfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GrappaConvfunc';
default{m,1}.entrystr = grappaconvfunc;
default{m,1}.searchpath = grappaconvpath;
default{m,1}.path = [grappaconvpath,grappaconvfunc];

