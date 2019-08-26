%=========================================================
% 
%=========================================================

function [default] = ImpType_ConesStd_v1i_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    SYSRESPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\SysResp Functions\']; 
    FINMETHpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\FinMeth Functions\']; 
elseif strcmp(filesep,'/')
end
FINMETHfunc = 'FinMeth_EndNoCompensate_v1a'; 
SYSRESPfunc = 'SysResp_FromFileNoComp_v1i'; 

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Slew (mT/m/ms)';
default{m,1}.entrystr = '150';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SolveFrac (%)';
default{m,1}.entrystr = '95';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DesGradPeriod (ms)';
default{m,1}.entrystr = '0.001';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ConesSpokes (0-1)';
default{m,1}.entrystr = '1';

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
