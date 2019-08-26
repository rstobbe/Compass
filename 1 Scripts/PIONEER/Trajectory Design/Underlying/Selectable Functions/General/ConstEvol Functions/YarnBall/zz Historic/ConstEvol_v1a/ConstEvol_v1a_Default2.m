%=========================================================
% 
%=========================================================

function [default] = ConstEvol_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\zz Common\LR\']));
    caccpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\LR\ConstrainAcc SubFunctions\ConsAcc Functions\'];
    cjerkpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\LR\ConstrainJerk SubFunctions\'];
    accprofpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\LR\ConstrainAcc SubFunctions\ConstAccProf Functions\'];
elseif strcmp(filesep,'/')
end
accproffunc = 'CAccProf_Uniform_v1b';
caccfunc = 'CAccMeth1_v1b';
cjerkfunc = 'CJerkMeth2_v1a';
addpath([caccpath,caccfunc]);
addpath([accprofpath,accproffunc]);
addpath([cjerkpath,cjerkfunc]);

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

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ConstJerkfunc';
default{m,1}.entrystr = cjerkfunc;
default{m,1}.searchpath = cjerkpath;
default{m,1}.path = [cjerkpath,cjerkfunc];