%=========================================================
% 
%=========================================================

function [default] = GWFM_ECC_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    GECCpath = [SCRPTPATHS.rootloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\GECC Functions\']; 
elseif strcmp(filesep,'/')
end
GECCfunc = 'GECC_LoadFile_v1a'; 
addpath([GECCpath,GECCfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GECCfunc';
default{m,1}.entrystr = GECCfunc;
default{m,1}.searchpath = GECCpath;
default{m,1}.path = [GECCpath,GECCfunc];



