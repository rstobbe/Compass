%=====================================================
%
%=====================================================

function [TORD,err] = TrajOrder_SubSetAverage_v1a_Func(TORD,INPUT)

Status2('busy','Write Trajectory Order',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
clear INPUT

%-------------------------------------------------
% Test Subset Multiple
%-------------------------------------------------
projsampscnr = IMP.PSMP.projsampscnr;
if rem(length(projsampscnr),TORD.subsetsize) ~= 0
    err.flag = 1;
    err.msg = 'SubSetSize must be a factor of trajectory number';
    return
end

%-------------------------------------------------
% SubSets
%-------------------------------------------------
Nsets = length(projsampscnr)/TORD.subsetsize;
Subsets = zeros(Nsets*TORD.averages,TORD.subsetsize);
for n = 1:Nsets
    for m = 1:TORD.averages
        Subsets((n-1)*TORD.averages+m,:) = projsampscnr((n-1)*TORD.subsetsize+1:n*TORD.subsetsize);
    end
end
Subsets = Subsets.';
projsampscnr = Subsets(:);
%figure(1234123)
%plot(projsampscnr);
TORD.projsampscnr = projsampscnr;
TORD.nsets = Nsets;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',TORD.method,'Output'};
Panel(3,:) = {'Subset Size',TORD.subsetsize,'Output'};
Panel(4,:) = {'Subset Number',TORD.nsets,'Output'};
Panel(5,:) = {'Averages',TORD.averages,'Output'};
Panel(6,:) = {'Total Trajectories',length(TORD.projsampscnr),'Output'};
Panel(7,:) = {'Trajectory Order','Straight','Output'};
TORD.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);






