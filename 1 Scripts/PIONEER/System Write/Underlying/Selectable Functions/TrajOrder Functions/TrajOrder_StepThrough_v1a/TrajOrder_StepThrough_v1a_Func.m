%=====================================================
%
%=====================================================

function [TORD,err] = TrajOrder_StepThrough_v1a_Func(TORD,INPUT)

Status2('busy','Reorder Trajectories',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
clear INPUT

%-------------------------------------------------
% Test
%-------------------------------------------------
if rem(IMP.impPROJdgn.nproj,TORD.step)
    err.flag = 1;
    err.msg = 'nproj not a multiple of step';
    return
end

%-------------------------------------------------
% Select/Order Trajectories
%-------------------------------------------------
TORD.projsampscnr0 = IMP.PSMP.projsampscnr;

for n = 1:TORD.step
    projsampscnr(n,:) = TORD.projsampscnr0(n:TORD.step:end);
end
TORD.projsampscnr = reshape(projsampscnr.',numel(projsampscnr),1);
TORD.trajpersweep = IMP.impPROJdgn.nproj/TORD.step;
TORD.timesegmentpossible = 'Yes';
TORD.images = TORD.step;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',TORD.method,'Output'};
Panel(3,:) = {'Total Trajectories',['As Design (',num2str(length(TORD.projsampscnr)),')'],'Output'};
Panel(4,:) = {'SegmentedImages',TORD.images,'Output'};
Panel(5,:) = {'TrajPerSweep',TORD.trajpersweep,'Output'};
TORD.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);






