%=========================================================
% 
%=========================================================

function [default] = GWFM_LR_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    TENDpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\TrajEnd Functions\']; 
    GECCpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\GComp Functions\']; 
    IGFpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\IGF Functions\']; 
elseif strcmp(filesep,'/')
end
TENDfunc = 'TrajEnd_LRrephase_v1a'; 
addpath([TENDpath,TENDfunc]);
GECCfunc = 'GComp_FromFile_v1b'; 
addpath([GECCpath,GECCfunc]);
IGFfunc = 'IGF_LRsmooth_v1a'; 
addpath([IGFpath,IGFfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'IGFfunc';
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


