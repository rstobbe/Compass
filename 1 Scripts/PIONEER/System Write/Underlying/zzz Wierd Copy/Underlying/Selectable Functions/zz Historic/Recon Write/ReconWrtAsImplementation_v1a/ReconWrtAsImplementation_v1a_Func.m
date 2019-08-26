%=====================================================
%
%=====================================================

function [RCNWRT,err] = ReconWrtAsImplementation_v1a_Func(RCNWRT,INPUT)

Status2('busy','Write Reconstruction Data',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
%if isfield(INPUT,'PSMP')
if isfield(IMP,'PSMP')                              % retrospectively corrected
    PSMP = IMP.PSMP;
else
    PSMP = struct();
end
clear INPUT

%-------------------------------------------------
% Select/Order Trajectories
%-------------------------------------------------
if isfield(PSMP,'projsampscnr')
    RCNWRT.projsampscnr = PSMP.projsampscnr;
else
    RCNWRT.projsampscnr = (1:IMP.impPROJdgn.nproj);
end

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',RCNWRT.method,'Output'};
Panel(3,:) = {'Total Trajectories',['As Design (',num2str(length(RCNWRT.projsampscnr)),')'],'Output'};
Panel(4,:) = {'Trajectory Order','Straight','Output'};
RCNWRT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);






