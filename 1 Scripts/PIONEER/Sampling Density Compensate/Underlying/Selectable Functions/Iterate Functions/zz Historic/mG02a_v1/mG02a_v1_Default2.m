%=========================================================
% 
%=========================================================

function [default] = mG02a_v1_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\zz Common\']));
    DOVPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\IE Functions\'];
    AccPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\SDC Kernel\'];
    AnlzPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\TF Functions\'];
    BreakPath = [SCRPTPATHS.rootloc,'Sampling Density Compensate\Underlying\Selectable Functions\Convolved TF Shape\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(DOVPath));
addpath(genpath(AccPath));
addpath(genpath(AnlzPath));
addpath(genpath(BreakPath));

DOVFunc = 'DOVG_v2';
AccFunc = 'AccSelect_v1';
AnlzFunc = 'GrdConvTst_v1';
BreakFunc = 'Iterations_v1';

m = 1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'DOVFunc';
default{m,1}.entrystr = DOVFunc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'AccFunc';
default{m,1}.entrystr = AccFunc;
default{m,1}.searchpath = AccPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'AnlzFunc';
default{m,1}.entrystr = AnlzFunc;
default{m,1}.searchpath = AnlzPath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'BreakFunc';
default{m,1}.entrystr = BreakFunc;
default{m,1}.searchpath = BreakPath;



