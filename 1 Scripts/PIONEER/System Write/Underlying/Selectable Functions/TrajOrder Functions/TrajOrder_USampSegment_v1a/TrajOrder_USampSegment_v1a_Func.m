%=====================================================
%
%=====================================================

function [TORD,err] = TrajOrder_USampSegment_v1a_Func(TORD,INPUT)

Status2('busy','Reorder Trajectories',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
DES = IMP.DES;
SPIN = DES.SPIN;
PSMP = IMP.PSMP;
clear INPUT

%-------------------------------------------------
% Test
%-------------------------------------------------
if not(isfield(SPIN,'discsegs'))
    err.flag = 1;
    err.msg = 'TrajOrder not relevant for trajectory';
    return
end
if SPIN.ndiscs ~= PSMP.ndiscs || SPIN.nspokes ~= PSMP.nppd
	error
end
% figure(1000); hold on;
% plot(PSMP.theta);
% plot(PSMP.phi);

%-------------------------------------------------
% Select/Order Trajectories
%-------------------------------------------------
projsampscnr0 = PSMP.projsampscnr;

tempprojsampscnr = [];
for p = 1:SPIN.discsegs
    for n = 1:SPIN.spokesegs
        for m = p:SPIN.discsegs:SPIN.ndiscs
            tempprojsampscnr = [tempprojsampscnr projsampscnr0((m-1)*SPIN.nspokes+n:SPIN.spokesegs:m*SPIN.nspokes)];
        end
    end
end
test = unique(tempprojsampscnr);
if length(test) ~= length(tempprojsampscnr)
    error
end
% figure(1001); hold on;
% plot(PSMP.phi(tempprojsampscnr));
% plot(PSMP.theta(tempprojsampscnr));

TORD.projsampscnr = tempprojsampscnr;
TORD.trajpersweep = IMP.impPROJdgn.nproj/(SPIN.spokesegs*SPIN.discsegs);
TORD.timesegmentpossible = 'Yes';
TORD.images = SPIN.spokesegs*SPIN.discsegs;

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






