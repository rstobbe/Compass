%=========================================================
% 
%=========================================================

function [default] = ImpType_YarnBallOutInDualEchoOptions_v1e_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    SYSRESPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\SysResp SubFunctions\']; 
elseif strcmp(filesep,'/')
end
SYSRESPfunc = 'SysResp_ForWindBackIn_v1h'; 

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SysRespfunc';
default{m,1}.entrystr = SYSRESPfunc;
default{m,1}.searchpath = SYSRESPpath;
default{m,1}.path = [SYSRESPpath,SYSRESPfunc];
