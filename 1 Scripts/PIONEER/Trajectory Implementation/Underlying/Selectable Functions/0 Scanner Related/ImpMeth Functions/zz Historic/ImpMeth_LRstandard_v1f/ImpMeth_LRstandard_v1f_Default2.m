%=========================================================
% 
%=========================================================

function [default] = ImpMeth_LRstandard_v1f_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    DEsoltimpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\LR\DEsoltim Functions\']; 
    accconstpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\LR\ConstEvol Functions\']; 
    TENDpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\TrajEnd Functions\']; 
    SYSRESPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\SysResp SubFunctions\']; 
    ORNTpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\Orient Functions\'];     
elseif strcmp(filesep,'/')
end
ORNTfunc = 'OrientStandard_v1a'; 
DEsoltimfunc = 'DeSolTim_LRMeth2_v1b';
accconstfunc = 'ConstEvol_v4c';
TENDfunc = 'TrajEnd_StandardRephase_v1d';
SYSRESPfunc = 'SysResp_FromFile_v1a'; 

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Orientfunc';
default{m,1}.entrystr = ORNTfunc;
default{m,1}.searchpath = ORNTpath;
default{m,1}.path = [ORNTpath,ORNTfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DeSolTimfunc';
default{m,1}.entrystr = DEsoltimfunc;
default{m,1}.searchpath = DEsoltimpath;
default{m,1}.path = [DEsoltimpath,DEsoltimfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ConstEvolfunc';
default{m,1}.entrystr = accconstfunc;
default{m,1}.searchpath = accconstpath;
default{m,1}.path = [accconstpath,accconstfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TEndfunc';
default{m,1}.entrystr = TENDfunc;
default{m,1}.searchpath = TENDpath;
default{m,1}.path = [TENDpath,TENDfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SysRespfunc';
default{m,1}.entrystr = SYSRESPfunc;
default{m,1}.searchpath = SYSRESPpath;
default{m,1}.path = [SYSRESPpath,SYSRESPfunc];

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'InitSampDiscard';
default{m,1}.entrystr = '0';
