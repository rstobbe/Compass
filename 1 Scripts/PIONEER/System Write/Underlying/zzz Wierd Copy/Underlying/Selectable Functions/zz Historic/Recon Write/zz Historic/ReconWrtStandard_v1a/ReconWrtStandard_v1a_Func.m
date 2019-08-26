%=====================================================
%
%=====================================================

function [RCNWRT,err] = ReconWrtStandard_v1a_Func(RCNWRT,INPUT)

Status2('busy','Write Reconstruction Data',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
SDCS = INPUT.SDCS;
clear INPUT

%-------------------------------------------------
% Select/Order Trajectories
%-------------------------------------------------
RCNWRT.projsampscnr = (1:IMP.impPROJdgn.nproj);

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',RCNWRT.method,'Output'};
Panel(3,:) = {'Total Trajectories','Full','Output'};
Panel(4,:) = {'Trajectory Order','Straight','Output'};
RCNWRT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);






