%====================================================
% (v1c) 
%       - Update for RWSUI_BA
%====================================================

function [SCRPTipt,TFOout,err] = TF_MatchSD_v1c(SCRPTipt,TFO)

Status('busy','Determine Output Transfer Function');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
PROJdgn = TFO.PROJdgn;

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(PROJdgn,'sdcTF'))
    err.flag = 1;
    err.msg = 'TFfunc ''TF_MatchSD'' not suitable for projection design';
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
TFOout.tf = PROJdgn.sdcTF; 
TFOout.r = PROJdgn.sdcR;

visuals = 0;
if visuals == 1
    figure; plot(TF.r,TF.tf);
end
