%=========================================================
% 
%=========================================================

function [default] = ConstEvol_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\zz Common\LR\']));
    caccpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\LR\ConstEvol SubFunctions\ConstAcc Functions\'];
    accprofpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\LR\ConstEvol SubFunctions\ConstAccProf Functions\'];
    cacctwkpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\LR\ConstEvol SubFunctions\ConstAccTweak Functions\'];
    cjerkpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\LR\ConstEvol SubFunctions\ConstJerk Functions\'];
elseif strcmp(filesep,'/')
end
caccfunc = 'CAccMeth1_v1b';
accproffunc = 'CAccProf_Uniform_v1b';
cacctwkfunc = 'CAccTwkMeth1_v1a';
cjerkfunc = 'CJerkMeth2_v1b';
addpath([caccpath,caccfunc]);
addpath([accprofpath,accproffunc]);
addpath([cacctwkpath,cacctwkfunc]);
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
default{m,1}.labelstr = 'ConstAccTwk';
default{m,1}.entrystr = cacctwkfunc;
default{m,1}.searchpath = cacctwkpath;
default{m,1}.path = [cacctwkpath,cacctwkfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ConstJerkfunc';
default{m,1}.entrystr = cjerkfunc;
default{m,1}.searchpath = cjerkpath;
default{m,1}.path = [cjerkpath,cjerkfunc];