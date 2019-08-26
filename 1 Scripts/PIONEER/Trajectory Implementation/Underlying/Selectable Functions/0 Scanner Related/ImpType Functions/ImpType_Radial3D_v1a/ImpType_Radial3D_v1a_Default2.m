%=========================================================
% 
%=========================================================

function [default] = ImpType_Radial3D_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    REVOpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\Rad3DEvo Functions\']; 
    SYSRESPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\SysResp Functions\']; 
    FINMETHpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\FinMeth Functions\']; 
elseif strcmp(filesep,'/')
end
REVOfunc = 'Rad3DEvo_RampFlat_v1a'; 
FINMETHfunc = 'FinMeth_EndNoCompensate_v1a'; 
SYSRESPfunc = 'SysResp_FromFileNoComp_v1i'; 

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Rad3DEvofunc';
default{m,1}.entrystr = REVOfunc;
default{m,1}.searchpath = REVOpath;
default{m,1}.path = [REVOpath,REVOfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'FinMethfunc';
default{m,1}.entrystr = FINMETHfunc;
default{m,1}.searchpath = FINMETHpath;
default{m,1}.path = [FINMETHpath,FINMETHfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SysRespfunc';
default{m,1}.entrystr = SYSRESPfunc;
default{m,1}.searchpath = SYSRESPpath;
default{m,1}.path = [SYSRESPpath,SYSRESPfunc];
