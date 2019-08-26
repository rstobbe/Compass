%=========================================================
% 
%=========================================================

function [default] = GWFM_ECC_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    TENDpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\TrajEnd Functions\']; 
    GECCpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\GECC Functions\']; 
elseif strcmp(filesep,'/')
end
TENDfunc = 'TrajEnd_LRrephase_v1a'; 
addpath([TENDpath,TENDfunc]);
GECCfunc = 'GECC_FromFile_v1a'; 
addpath([GECCpath,GECCfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TEndfunc';
default{m,1}.entrystr = TENDfunc;
default{m,1}.searchpath = TENDpath;
default{m,1}.path = [TENDpath,TENDfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GECCfunc';
default{m,1}.entrystr = GECCfunc;
default{m,1}.searchpath = GECCpath;
default{m,1}.path = [GECCpath,GECCfunc];


