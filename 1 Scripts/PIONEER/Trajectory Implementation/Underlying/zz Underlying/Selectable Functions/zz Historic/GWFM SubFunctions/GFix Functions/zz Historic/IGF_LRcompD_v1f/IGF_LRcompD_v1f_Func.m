%=====================================================
% 
%=====================================================

function [IGF,err] = IGF_LRcompD_v1f_Func(IGF,INPUT)

Status2('busy','Initial Gradient Fix',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G0 = INPUT.G0;
GQNT = INPUT.GQNT;
clear INPUT
qTtraj = GQNT.scnrarr;
nproj = length(G0(:,1,1));

%---------------------------------------------
% Calculate Steps
%---------------------------------------------
%m = (2:length(G0(1,:,1))-2);
%cartgsteps = [G0(:,1,:) G0(:,m,:)-G0(:,m-1,:)];
%cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];

%---------------------------------------------
% Plot
%---------------------------------------------
%t = qTtraj(2:length(qTtraj)-2);
%figure(1102); hold on;
%plot(t,cartgsteps(1,:,1),'b:'); plot(t,cartgsteps(1,:,2),'g:'); plot(t,cartgsteps(1,:,3),'r:');
%xlabel('Trajectory Step Number','fontsize',10,'fontweight','bold');
%ylabel('Gradient Step (mT/m)','fontsize',10,'fontweight','bold');
%figure(1103); hold on;
%plot(t,cartg2drv(1,:,1),'b:'); plot(t,cartg2drv(1,:,2),'g:'); plot(t,cartg2drv(1,:,3),'r:');
%xlabel('Trajectory Step Number','fontsize',10,'fontweight','bold');
%ylabel('Gradient Step Change (mT/m)','fontsize',10,'fontweight','bold');

%---------------------------------------------
% Smooth
%---------------------------------------------
smthto = length(G0(1,:,1));
G0(1,1:smthto,1) = smooth(G0(1,1:smthto,1),11);
G0(1,1:smthto,2) = smooth(G0(1,1:smthto,2),11);
G0(1,1:smthto,3) = smooth(G0(1,1:smthto,3),11);

%---------------------------------------------
% Calculate Steps
%---------------------------------------------
m = (2:length(G0(1,:,1))-2);
cartgsteps = [G0(:,1,:) G0(:,m,:)-G0(:,m-1,:)];
cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];

%---------------------------------------------
% Plot
%---------------------------------------------
t = qTtraj(2:length(qTtraj)-2);
figure(1102); hold on;
plot(t,cartgsteps(1,:,1),'b-'); plot(t,cartgsteps(1,:,2),'g-'); plot(t,cartgsteps(1,:,3),'r-');
xlabel('Trajectory Step Number','fontsize',10,'fontweight','bold');
ylabel('Gradient Step (mT/m)','fontsize',10,'fontweight','bold');
figure(1103); hold on;
plot(t,cartg2drv(1,:,1),'b-'); plot(t,cartg2drv(1,:,2),'g-'); plot(t,cartg2drv(1,:,3),'r-');
xlabel('Trajectory Step Number','fontsize',10,'fontweight','bold');
ylabel('Gradient Step Change (mT/m)','fontsize',10,'fontweight','bold');

%----------------------------------------------------
% Visuals
%----------------------------------------------------
Gvis = []; L = [];
for n = 1:length(qTtraj)-1
    L = [L [qTtraj(n) qTtraj(n+1)]];
    Gvis = [Gvis [G0(:,n,:) G0(:,n,:)]];
end
figure(1000); hold on; plot(L,Gvis(1,:,1),'b-'); plot(L,Gvis(1,:,2),'g-'); plot(L,Gvis(1,:,3),'r-'); %xlim([0 0.4]);
if nproj > 1
    figure(1001); hold on; plot(L,Gvis(ceil(nproj/4),:,1),'b-'); plot(L,Gvis(ceil(nproj/4),:,2),'g-'); plot(L,Gvis(ceil(nproj/4),:,3),'r-');  %xlim([0 0.4]); 
    figure(1002); hold on; plot(L,Gvis(nproj-1,:,1),'b-'); plot(L,Gvis(nproj-1,:,2),'g-'); plot(L,Gvis(nproj-1,:,3),'r-');  %xlim([0 0.4]);
end


error();



%---
GchgMx = IGF.Gaccmx*GQNT.gseg;
GMxInit = IGF.Gaccmx*GQNT.gseg;
GMx = IGF.Gvelmx*GQNT.gseg;
ind = 50*ind;
GcompMx = IGF.Gcompstpmx;
%---



%---------------------------------------------
% Fix
%---------------------------------------------
stop = 0;
for n = 1:length(G0(:,1,1))

    G(n,:,:) = G0(n,:,:);
    Gstep0 = squeeze(G(n,1,:));
    G(n,1,abs(Gstep0) > GMxInit) = sign(Gstep0(abs(Gstep0) > GMxInit))*GMxInit;
    Gleft = zeros(3,1);
    Gleft(abs(Gstep0) > GMxInit) = Gstep0(abs(Gstep0) > GMxInit) - sign(Gstep0(abs(Gstep0) > GMxInit))*GMxInit;
    G(n,2,:) = squeeze(G(n,2,:)) + Gleft;
    GstepP = squeeze(G(n,1,:));
    for m = 2:ind
        GstepD = squeeze(G0(n,m,:) - G0(n,m-1,:)); 
        Gstep0 = squeeze(G(n,m,:) - G(n,m-1,:));            
        Gchg = Gstep0-GstepP;
        Gstep = Gstep0;
        Gstep(Gchg>GchgMx) = GstepP(Gchg>GchgMx)+GchgMx;
        Gstep(Gchg<-GchgMx) = GstepP(Gchg<-GchgMx)-GchgMx;
        %Gstep(Gstep > 1.5*GstepD) = 1.1*GstepD(Gstep > 1.5*GstepD);
        %Gstep(Gstep < -1.5*GstepD) = -1.1*GstepD(Gstep < -1.5*GstepD);
        Gstep(Gstep > GMx) = GMx;
        Gstep(Gstep < -GMx) = -GMx;

        G(n,m,:) = squeeze(G(n,m-1,:)) + Gstep;
        Gleft = squeeze(sum(G0(n,1:m,:),2) - sum(G(n,1:m,:),2));
        if sum(Gleft) == 0
            stop = 1;
            break
        end
        Gleft(Gleft>GcompMx) = GcompMx;
        Gleft(Gleft<-GcompMx) = -GcompMx;
        if m == 120
            test = 1;
        end
        G(n,m+1,:) = squeeze(G0(n,m+1,:)) + Gleft;
        GstepP = Gstep;
    end
    
end

if stop ~= 1
    error
end

%---------------------------------------------
% Steps
%---------------------------------------------
m = (2:length(G(1,:,1))-2);
cartgsteps = [G(:,1,:) G(:,m,:)-G(:,m-1,:)];
cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];

%---------------------------------------------
% Plot
%---------------------------------------------
figure(1102); hold on;
plot(cartgsteps(1,:,1),'b','linewidth',2); plot(cartgsteps(1,:,2),'g','linewidth',2); plot(cartgsteps(1,:,3),'r','linewidth',2);
xlabel('Trajectory Step Number','fontsize',10,'fontweight','bold');
ylabel('Gradient Step (mT/m)','fontsize',10,'fontweight','bold');
xlim([0 3*ind]);
figure(1103); hold on;
plot(cartg2drv(1,:,1),'b','linewidth',2); plot(cartg2drv(1,:,2),'g','linewidth',2); plot(cartg2drv(1,:,3),'r','linewidth',2);
xlabel('Trajectory Step Number','fontsize',10,'fontweight','bold');
ylabel('Gradient Step Change (mT/m)','fontsize',10,'fontweight','bold');
xlim([0 3*ind]);

%---------------------------------------------
% Return
%---------------------------------------------
IGF.G0fix = G;

Status2('done','',2);
Status2('done','',3);
