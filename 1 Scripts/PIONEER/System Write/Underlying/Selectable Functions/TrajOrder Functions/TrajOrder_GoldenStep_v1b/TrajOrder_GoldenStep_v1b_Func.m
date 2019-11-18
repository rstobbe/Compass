%=====================================================
%
%=====================================================

function [TORD,err] = TrajOrder_GoldenStep_v1b_Func(TORD,INPUT)

Status2('busy','Reorder Trajectories (Golden)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
clear INPUT

%-------------------------------------------------
% Select/Order Trajectories
%-------------------------------------------------
projsampscnr0 = IMP.PSMP.projsampscnr;

%-----------------------------------------------
% Calculate Step Through
%-----------------------------------------------
nproj = IMP.impPROJdgn.nproj;
goldenrat = (1+sqrt(5))/2;
step = (nproj-1)/goldenrat;
traj(1) = 0;
for n = 1:(nproj-1)
    traj(n+1) = rem((traj(n)+step),(nproj-1));
%     figure(12341); hold on;
%     plot(traj(n+1)+1,1,'*');
%     xlim([1 nproj]);
%     drawnow;
end
[sorttraj,ind] = sort(round(traj));
%--
% figure(12342); hold on;
% plot(sorttraj); 
%--
projsampscnr(ind) = projsampscnr0;                  % should be ~same as traj * factor for undersampling recon
%--
% figure(12343); hold on;
% plot(traj); 
% plot(projsampscnr); 
% xlim([1 200]);
% figure(12344); hold on;
% plot(traj); 
% plot(projsampscnr); 
% xlim([2001 2200]);
%--

%-------------------------------------------------
% Select/Order Trajectories
%-------------------------------------------------
TORD.projsampscnr = projsampscnr.';
TORD.trajpersweep = [];
TORD.timesegmentpossible = 'Yes';
TORD.images = [];
if isfield(IMP.PSMP,'azireconosampfact')
    TORD.SdcOverSamp = IMP.PSMP.azireconosampfact*IMP.PSMP.polreconosampfact;
else
    TORD.SdcOverSamp = 1;
end

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',TORD.method,'Output'};
TORD.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);






