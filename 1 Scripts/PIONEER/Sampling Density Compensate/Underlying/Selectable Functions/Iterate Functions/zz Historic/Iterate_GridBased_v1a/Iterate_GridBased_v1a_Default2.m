%=========================================================
% 
%=========================================================

function [default] = Iterate_GridBased_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\zz Common\']));
    AccPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\Iterate SubFunctions\Acc Functions\'];
    AnlzPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\Iterate SubFunctions\Anlz Functions\'];
    BreakPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Underlying\Selectable Functions\Iterate SubFunctions\Break Functions\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(AccPath));
addpath(genpath(AnlzPath));
addpath(genpath(BreakPath));

AccFunc = 'Acc_None_v1a';
AnlzFunc = 'Anlz_GridBased_v1a';
BreakFunc = 'Break_Iterations_v1a';

m = 1;
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


