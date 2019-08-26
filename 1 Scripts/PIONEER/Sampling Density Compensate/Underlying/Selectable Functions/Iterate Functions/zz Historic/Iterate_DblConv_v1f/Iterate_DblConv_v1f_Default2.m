%=========================================================
% 
%=========================================================

function [default] = Iterate_DblConv_v1f_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.pioneerloc,'Sampling Density Compensate\Underlying\zz Underlying\zz Common\']));
    AccPath = [SCRPTPATHS.pioneerloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\Iterate SubFunctions\Acc Functions\'];
    AnlzPath = [SCRPTPATHS.pioneerloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\Iterate SubFunctions\Anlz Functions\'];
    BreakPath = [SCRPTPATHS.pioneerloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\Iterate SubFunctions\Break Functions\'];
elseif strcmp(filesep,'/')
end
AccFunc = 'Acc_None_v1c';
AnlzFunc = 'Anlz_TPI_v1g';
BreakFunc = 'Break_Iterations_v1c';
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

