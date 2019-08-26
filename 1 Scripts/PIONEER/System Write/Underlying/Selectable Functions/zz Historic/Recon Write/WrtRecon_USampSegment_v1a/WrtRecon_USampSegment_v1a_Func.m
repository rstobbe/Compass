%=====================================================
%
%=====================================================

function [RCNWRT,err] = ReconWrtStepThrough_v1a_Func(RCNWRT,INPUT)

Status2('busy','Write Reconstruction Data',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
PSMP = IMP.PSMP;
clear INPUT

%-------------------------------------------------
% Test
%-------------------------------------------------
if rem(IMP.impPROJdgn.nproj,RCNWRT.step)
    err.flag = 1;
    err.msg = 'nproj not a multiple of step';
    return
end

%-------------------------------------------------
% Select/Order Trajectories
%-------------------------------------------------
if isfield(PSMP,'projsampscnr')
    projsampscnr0 = PSMP.projsampscnr;
else
    projsampscnr0 = (1:IMP.impPROJdgn.nproj);
end

for n = 1:RCNWRT.step
    projsampscnr(n,:) = projsampscnr0(n:RCNWRT.step:end);
end
RCNWRT.projsampscnr = reshape(projsampscnr.',numel(projsampscnr),1);
RCNWRT.trajpersweep = IMP.impPROJdgn.nproj/RCNWRT.step;
RCNWRT.timesegmentpossible = 'Yes';

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',RCNWRT.method,'Output'};
Panel(3,:) = {'Total Trajectories',['As Design (',num2str(length(RCNWRT.projsampscnr)),')'],'Output'};
Panel(4,:) = {'TrajectoryStep',RCNWRT.step,'Output'};
Panel(5,:) = {'TrajPerSweep',RCNWRT.trajpersweep,'Output'};
Panel(5,:) = {'TimeSegmentPossible',RCNWRT.timesegmentpossible,'Output'};
RCNWRT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);






