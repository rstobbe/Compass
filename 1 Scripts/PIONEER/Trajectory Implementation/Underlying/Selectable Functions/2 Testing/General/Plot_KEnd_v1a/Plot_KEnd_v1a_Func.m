%==================================================
% 
%==================================================

function [PLOT,err] = Plot_KEnd_v1a_Func(PLOT,INPUT)

Status2('busy','Plot k-End',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
IMP = INPUT.IMP;
PROJdgn = IMP.PROJdgn;
PSMP = IMP.PSMP;
clear INPUT

kEnd = squeeze(IMP.Kend);
kEndMag = sqrt(kEnd(:,1).^2 + kEnd(:,2).^2 + kEnd(:,3).^2);

ind = length(IMP.G(1,:,1));
while true
    x = IMP.G(:,ind,1);
    ind2 = find(x ~= 0,1);
    if not(isempty(ind2))
        traj = ind2;
        dir = 1;
        break
    end
    y = IMP.G(:,ind,2);
    ind2 = find(y ~= 0,1);
    if not(isempty(ind2))
        traj = ind2;
        dir = 2;
        break
    end
    z = IMP.G(:,ind,3);
    ind2 = find(z ~= 0,1);
    if not(isempty(ind2))
        traj = ind2;
        dir = 3;
        break
    end   
    ind = ind - 1;
end

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
clr = ['b','g','r'];
%clr = ['c','m','y'];

kEnd = kEnd/PROJdgn.kmax;
kEndMag = kEndMag/PROJdgn.kmax;

figure(34573); hold on; box on;
plot(kEnd(:,1),clr(1));
plot(kEnd(:,2),clr(2));
plot(kEnd(:,3),clr(3));
%plot(kEndMag,'k');
%xlim([0 PROJdgn.nproj]);
xlabel('Trajectory');
ylabel('kMax Multiple');

nppd = PSMP.nppd;
nproj = PSMP.nproj;
ind = find(kEnd(:,3)==max(kEnd(:,3)));
arr = ind+(-nproj:nppd:nproj);
start = find(arr>0,1,'first');
stop = find(arr<nproj,1,'last');
arr2 = arr(start:stop);
plot(arr2,kEnd(arr2,3),'k*');

figure(34575); hold on; box on;
% plot(kEnd(arr2,1),clr(1));
% plot(kEnd(arr2,2),clr(2));
% plot(kEnd(arr2,3),clr(3));

plot(kEnd(arr2-20,1),clr(1));
plot(kEnd(arr2-20,2),clr(2));
plot(kEnd(arr2-20,3),clr(3));

plot(kEnd(arr2-21,1),clr(1));
plot(kEnd(arr2-21,2),clr(2));
plot(kEnd(arr2-21,3),clr(3));


% plot(kEnd(arr2-1,1),clr(1));
% plot(kEnd(arr2-1,2),clr(2));
% plot(kEnd(arr2-1,3),clr(3));

traj = 1;
% figure(1235123); hold on;
% plot(IMP.qTscnr(1:end-1),IMP.G(traj,:,1),clr(1));
% plot(IMP.qTscnr(1:end-1),IMP.G(traj,:,2),clr(2));
% plot(IMP.qTscnr(1:end-1),IMP.G(traj,:,3),clr(3));

% ylim([-60 60]);
% title(['Traj',num2str(N)]);
% xlabel('(ms)','fontsize',10,'fontweight','bold');
% ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
% fh.Units = 'inches';
% fh.Position = [5 5 3 2.4];

% PolarAng = acos(kEnd(:,3)./kEndMag);
% AziAng = atan(kEnd(:,2)./kEnd(:,1));
% figure(34574); hold on; box on;
% plot(PolarAng,'r');
% plot(AziAng,'b');
% 
% [B,inds] = sort(PolarAng);
% figure(34575); hold on; box on;
% plot(B,'r');
% 
% figure(34576); hold on; box on;
% kEnd = kEnd/PROJdgn.kmax;
% kEndMag = kEndMag/PROJdgn.kmax;
% plot(kEnd(inds,1),clr(1));
% plot(kEnd(inds,2),clr(2));
% plot(kEnd(inds,3),clr(3));
% plot(kEndMag(inds),'k');
% xlabel('Trajectory');
% ylabel('kMax Multiple');

