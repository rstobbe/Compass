%=====================================================
% 
%=====================================================

function [SYSRESP,err] = SysResp_noResp_v1a_Func(SYSRESP,INPUT)

Status2('busy','No System Response',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G0;
T = INPUT.T;
mode = INPUT.mode;
clear INPUT

%==================================================================
% Compensate 
%==================================================================
if strcmp(mode,'Compensate')
    SYSRESP.Gcomp = G;
    SYSRESP.Tcomp = T;
    SYSRESP.efftrajdel = 0;                                  % for calculating end of trajectory
    Status2('done','',3);
    return
end

%==================================================================
% Analyze
%==================================================================
if strcmp(mode,'Analyze')
    SYSRESP.Grecon = G;
    SYSRESP.Trecon = T;
    SYSRESP.efftrajdel = 0;
    Status2('done','',3);
end
