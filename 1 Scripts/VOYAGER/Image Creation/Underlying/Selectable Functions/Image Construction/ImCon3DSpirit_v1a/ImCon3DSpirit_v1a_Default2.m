%=========================================================
% 
%=========================================================

function [default] = ImCon3DSpirit_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    grappakernpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Grappa\Grappa Kernels\'];
    grappacaldatextpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Grappa\Grappa CalDat Extract\'];
    grappawcalcpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Grappa\Grappa Weight Calc\'];
    grappaacalcpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Grappa\Grappa Adjoint Calc\'];
    grappaconvpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Grappa\Grappa Convolution\'];
    gridpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\kSpace Gridding\'];    
    gridrevpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Reverse Gridding\']; 
elseif strcmp(filesep,'/')
end
grappakernfunc = 'GrappaKernCube_v1a';
grappacaldatextfunc = 'GrappaCalDatExtCube_v1a';
grappawcalcfunc = 'GrappaWCalc_v1b';
grappaacalcfunc = 'GrappaACalc_v1a';
grappaconvfunc = 'GrappaConv_v1b';
gridfunc = 'GridkSpace_ExtKern_v1c';
gridrevfunc = 'GridReverse_ExtKern_v1c';
addpath([grappakernpath,grappakernfunc]);
addpath([grappacaldatextpath,grappacaldatextfunc]);
addpath([grappawcalcpath,grappawcalcfunc]);
addpath([grappaacalcpath,grappaacalcfunc]);
addpath([grappaconvpath,grappaconvfunc]);
addpath([gridpath,gridfunc]);
addpath([gridrevpath,gridrevfunc]);

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'No';
default{m,1}.runfunc2 = 'LoadTrajImpDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'No';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'SDC_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadSDCCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'No';
default{m,1}.runfunc2 = 'LoadSDCDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'No';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
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
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Gridfunc';
default{m,1}.entrystr = gridfunc;
default{m,1}.searchpath = gridpath;
default{m,1}.path = [gridpath,gridfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GridRevfunc';
default{m,1}.entrystr = gridrevfunc;
default{m,1}.searchpath = gridrevpath;
default{m,1}.path = [gridrevpath,gridrevfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GrappaKernfunc';
default{m,1}.entrystr = grappakernfunc;
default{m,1}.searchpath = grappakernpath;
default{m,1}.path = [grappakernpath,grappakernfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GrappaCalDatfunc';
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
default{m,1}.labelstr = 'GrappaACalcfunc';
default{m,1}.entrystr = grappaacalcfunc;
default{m,1}.searchpath = grappaacalcpath;
default{m,1}.path = [grappaacalcpath,grappaacalcfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GrappaConvfunc';
default{m,1}.entrystr = grappaconvfunc;
default{m,1}.searchpath = grappaconvpath;
default{m,1}.path = [grappaconvpath,grappaconvfunc];

