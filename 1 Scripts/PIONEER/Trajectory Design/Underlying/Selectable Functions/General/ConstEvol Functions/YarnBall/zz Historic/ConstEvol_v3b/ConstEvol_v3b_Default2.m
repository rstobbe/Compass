%=========================================================
% 
%=========================================================

function [default] = ConstEvol_v3b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\zz Common\LR\']));
    caccpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\LR\ConstEvol SubFunctions\ConstAcc Functions\'];
    accprofpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\LR\ConstEvol SubFunctions\ConstAccProf Functions\'];
elseif strcmp(filesep,'/')
end
caccfunc = 'CAccMeth1_v1b';
accproffunc = 'CAccProf_Uniform_v1b';
addpath([caccpath,caccfunc]);
addpath([accprofpath,accproffunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ConstAccfunc';
default{m,1}.entrystr = caccfunc;
default{m,1}.searchpath = caccpath;
default{m,1}.path = [caccpath,caccfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ConstAccProf';
default{m,1}.entrystr = accproffunc;
default{m,1}.searchpath = accprofpath;
default{m,1}.path = [accprofpath,accproffunc];
