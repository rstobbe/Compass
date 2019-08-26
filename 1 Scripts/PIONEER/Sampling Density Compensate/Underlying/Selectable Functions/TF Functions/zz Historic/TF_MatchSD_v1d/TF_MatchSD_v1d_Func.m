%====================================================
% (v1c) 
%       - Update for RWSUI_BA
%====================================================

function [TF,err] = TF_MatchSD_v1d_Func(TF,INPUT)

Status2('busy','Determine Output Transfer Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
PROJdgn = INPUT.IMP.impPROJdgn;

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
TF.tf = PROJdgn.sdcTF; 
TF.r = PROJdgn.sdcR;

visuals = 0;
if visuals == 1
    figure; plot(TF.r,TF.tf);
end

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'TF_Shape','MatchSD','Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TF.PanelOutput = PanelOutput;
