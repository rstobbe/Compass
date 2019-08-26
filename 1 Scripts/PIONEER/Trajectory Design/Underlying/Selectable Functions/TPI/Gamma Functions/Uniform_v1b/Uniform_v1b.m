%====================================================
% (v1b)
%       - update for RWSUI_GBL
%====================================================

function [SCRPTipt,GAMFUNCout,err] = Uniform_v1b(SCRPTipt,GAMFUNC)

Status('busy','Define Gamma Design Function');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Check for Return;
%---------------------------------------------
if strcmp(GAMFUNC.runfunc,'ReturnInputOnly');
    GAMFUNCout = struct();
    return
end

%---------------------------------------------
% Define Function
%---------------------------------------------
GAMFUNCout.GamFunc = @(r,p) (1/p^2); 
