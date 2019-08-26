%=========================================================
% 
%=========================================================

function [default] = ConstEvol3D_v3c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    caccpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\LR\ConstEvol SubFunctions\ConstAcc Functions\'];
elseif strcmp(filesep,'/')
end
caccfunc = 'CAccMeth1_v1b';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ConstAccfunc';
default{m,1}.entrystr = caccfunc;
default{m,1}.searchpath = caccpath;
default{m,1}.path = [caccpath,caccfunc];

