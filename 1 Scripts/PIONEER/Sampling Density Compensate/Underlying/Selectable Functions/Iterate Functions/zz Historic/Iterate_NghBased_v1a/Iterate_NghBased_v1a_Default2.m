%=========================================================
% 
%=========================================================

function [default] = Iterate_NghBased_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\zz Common\']));
    FindPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\Iterate SubFunctions\NGHConv Functions\Find Neighbour Functions\'];
    KernValPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\Iterate SubFunctions\NGHConv Functions\KernVal Functions\'];
    ConvPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\Iterate SubFunctions\NGHConv Functions\Convolve Functions\'];    
    AccPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\Iterate SubFunctions\Acc Functions\'];
    AnlzPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\Iterate SubFunctions\Anlz Functions\'];
    BreakPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\Iterate SubFunctions\Break Functions\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(FindPath));
addpath(genpath(KernValPath));
addpath(genpath(ConvPath));
addpath(genpath(AccPath));
addpath(genpath(AnlzPath));
addpath(genpath(BreakPath));

FindFunc = 'mFindNghbrsCUDA_v1f';
KernValFunc = 'SlvNghKrnVals_v3a';
ConvFunc = 'ConvNghbrs_v3a';
AccFunc = 'Acc_None_v1a';
AnlzFunc = 'Anlz_GridBased_v1a';
BreakFunc = 'Break_Iterations_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Findfunc';
default{m,1}.entrystr = FindFunc;
default{m,1}.searchpath = FindPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'KernValfunc';
default{m,1}.entrystr = KernValFunc;
default{m,1}.searchpath = KernValPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Convfunc';
default{m,1}.entrystr = ConvFunc;
default{m,1}.searchpath = ConvPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Accfunc';
default{m,1}.entrystr = AccFunc;
default{m,1}.searchpath = AccPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Anlzfunc';
default{m,1}.entrystr = AnlzFunc;
default{m,1}.searchpath = AnlzPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Breakfunc';
default{m,1}.entrystr = BreakFunc;
default{m,1}.searchpath = BreakPath;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'IterationVisuals';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'On','Off'};

