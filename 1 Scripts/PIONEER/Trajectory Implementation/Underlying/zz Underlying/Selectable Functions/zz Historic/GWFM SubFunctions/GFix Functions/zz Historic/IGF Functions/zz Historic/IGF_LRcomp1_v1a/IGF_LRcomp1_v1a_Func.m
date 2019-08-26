%=====================================================
% 
%=====================================================

function [IGF,err] = IGF_LRcomp1_v1a_Func(IGF,INPUT)

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

%---------------------------------------------
% Steps
%---------------------------------------------
m = (2:length(G0(1,:,1))-2);
cartgsteps = [G0(:,1,:) G0(:,m,:)-G0(:,m-1,:)];
cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];

%---------------------------------------------
% Max Comp Length
%---------------------------------------------
vecgsteps = sqrt(cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2);
mvecgsteps = mean(vecgsteps,1);
ind = find(mvecgsteps <= mean(mvecgsteps)*0.95,1,'last');

%---------------------------------------------
% Plot
%---------------------------------------------
%figure(1101); hold on;
%plot(mvecgsteps);
%xlabel('Trajectory Step Number','fontsize',10,'fontweight','bold');
%ylabel('Gradient Step (mT/m)','fontsize',10,'fontweight','bold');
figure(1102); hold on;
plot(cartgsteps(1,:,1),'b'); plot(cartgsteps(1,:,2),'g'); plot(cartgsteps(1,:,3),'r');
xlabel('Trajectory Step Number','fontsize',10,'fontweight','bold');
ylabel('Gradient Step (mT/m)','fontsize',10,'fontweight','bold');
xlim([0 3*ind]);
figure(1103); hold on;
plot(cartg2drv(1,:,1),'b'); plot(cartg2drv(1,:,2),'g'); plot(cartg2drv(1,:,3),'r');
xlabel('Trajectory Step Number','fontsize',10,'fontweight','bold');
ylabel('Gradient Step Change (mT/m)','fontsize',10,'fontweight','bold');
xlim([0 5*ind]);

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
        Gstep0 = squeeze(G(n,m,:) - G(n,m-1,:));            
        Gchg = Gstep0-GstepP;
        Gstep = Gstep0;
        Gstep(Gchg>GchgMx) = GstepP(Gchg>GchgMx)+GchgMx;
        Gstep(Gchg<-GchgMx) = GstepP(Gchg<-GchgMx)-GchgMx;
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
