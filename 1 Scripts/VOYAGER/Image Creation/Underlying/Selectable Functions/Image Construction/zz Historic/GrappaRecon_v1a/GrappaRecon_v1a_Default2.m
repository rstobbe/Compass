%====================================================
%
%====================================================

function [default] = GrappaRecon_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    grappakernpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Grappa\Grappa Kernels\'];
    grappacaldatextpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Grappa\Grappa CalDat Extract\'];
    grappawcalcpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Grappa\Grappa Weight Calc\'];
elseif strcmp(filesep,'/')
end
grappakernfunc = 'GrappaKernCube_v1a';
grappacaldatextfunc = 'GrappaCalDatExt_v1a';
grappawcalcfunc = 'GrappaWCalc_v1a';
addpath([grappakernpath,grappakernfunc]);
addpath([grappacaldatextpath,grappacaldatextfunc]);
addpath([grappawcalcpath,grappawcalcfunc]);

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
