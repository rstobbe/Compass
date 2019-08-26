%====================================================
% (v1b)
%       - update for RWSUI_GBL
%====================================================

function [SCRPTipt,GAMFUNCout,err] = GenHam_v1b(SCRPTipt,GAMFUNC)

Status('busy','Define Gamma Design Function');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GAMFUNCout = struct();
switch GAMFUNC.input
    case 'External Input'
        GAMFUNCout.N = GAMFUNC.N;
    case 'Panel Input'       
        GAMFUNCout.N = str2double(GAMFUNC.('GamEdgeVal'));
end

%---------------------------------------------
% Check for Return;
%---------------------------------------------
if strcmp(GAMFUNC.runfunc,'ReturnInputOnly');
    return
end

%---------------------------------------------
% Define Function
%---------------------------------------------
N = GAMFUNCout.N;
GAMFUNCout.GamFunc = @(r,p) (N+((1/p - N)/(1 - cos(pi*(1+p)))) - ((1/p - N)/(1 - cos(pi*(1+p))))*(cos(pi*(1+r))))/p;



