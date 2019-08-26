%=========================================================
% 
%=========================================================

function [default] = GWFM_Spiral1_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    TENDpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\TrajEnd Functions\']; 
    GECCpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\GComp Functions\']; 
    IGFpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\IGF Functions\']; 
    GBLDpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\GBuild Functions\']; 
elseif strcmp(filesep,'/')
end
IGFfunc = 'IGF_LRsmooth_v1a'; 
addpath([IGFpath,IGFfunc]);
TENDfunc = 'TrajEnd_LRrephase_v1a';
addpath([TENDpath,TENDfunc]);
GECCfunc = 'GComp_FromFile_v1b'; 
addpath([GECCpath,GECCfunc]);
GBLDfunc = 'GBuild_TempRotate_v1a'; 
addpath([GBLDpath,GBLDfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GFixfunc';
default{m,1}.entrystr = IGFfunc;
default{m,1}.searchpath = IGFpath;
default{m,1}.path = [IGFpath,IGFfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TEndfunc';
default{m,1}.entrystr = TENDfunc;
default{m,1}.searchpath = TENDpath;
default{m,1}.path = [TENDpath,TENDfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GCompfunc';
default{m,1}.entrystr = GECCfunc;
default{m,1}.searchpath = GECCpath;
default{m,1}.path = [GECCpath,GECCfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GBuildfunc';
default{m,1}.entrystr = GBLDfunc;
default{m,1}.searchpath = GBLDpath;
default{m,1}.path = [GBLDpath,GBLDfunc];
