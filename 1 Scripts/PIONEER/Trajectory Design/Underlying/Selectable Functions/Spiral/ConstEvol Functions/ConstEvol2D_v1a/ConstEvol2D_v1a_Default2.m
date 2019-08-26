%=========================================================
% 
%=========================================================

function [default] = ConstEvol_v3c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\zz Common\LR\']));
    caccpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\LR\ConstEvol SubFunctions\ConstAcc Functions\'];
elseif strcmp(filesep,'/')
end
caccfunc = 'CAccMeth1_v1b';
addpath([caccpath,caccfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ConstAccfunc';
default{m,1}.entrystr = caccfunc;
default{m,1}.searchpath = caccpath;
default{m,1}.path = [caccpath,caccfunc];

