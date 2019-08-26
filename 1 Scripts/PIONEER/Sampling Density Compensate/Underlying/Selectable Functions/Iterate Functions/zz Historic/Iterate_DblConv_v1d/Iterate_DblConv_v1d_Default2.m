%=========================================================
% 
%=========================================================

function [default] = Iterate_DblConv_v1d_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\zz Common\']));
    AccPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\Iterate SubFunctions\Acc Functions\'];
    AnlzPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\Iterate SubFunctions\Anlz Functions\'];
    BreakPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\Iterate SubFunctions\Break Functions\'];
elseif strcmp(filesep,'/')
end
AccFunc = 'Acc_None_v1b';
AnlzFunc = 'Anlz_GridBased_v1c';
BreakFunc = 'Break_Iterations_v1b';
addpath([AccPath,AccFunc]);
addpath([AnlzPath,AnlzFunc]);
addpath([BreakPath,BreakFunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxRelChange';
default{m,1}.entrystr = '1.5';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Accfunc';
default{m,1}.entrystr = AccFunc;
default{m,1}.searchpath = AccPath;
default{m,1}.path = [AccPath,AccFunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Anlzfunc';
default{m,1}.entrystr = AnlzFunc;
default{m,1}.searchpath = AnlzPath;
default{m,1}.path = [AnlzPath,AnlzFunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Breakfunc';
default{m,1}.entrystr = BreakFunc;
default{m,1}.searchpath = BreakPath;
default{m,1}.path = [BreakPath,BreakFunc];

