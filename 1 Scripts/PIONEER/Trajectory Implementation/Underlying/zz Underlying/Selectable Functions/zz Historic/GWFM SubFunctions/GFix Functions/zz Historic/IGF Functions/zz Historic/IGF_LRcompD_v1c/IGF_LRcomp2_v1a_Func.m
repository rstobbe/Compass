%=====================================================
% 
%=====================================================

function [IGF,err] = IGF_LRcomp2_v1a_Func(IGF,INPUT)

Status2('busy','Initial Gradient Fix',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G0 = INPUT.G0;
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
xlim([0 3*ind]);

%---------------------------------------------
% Fix
%---------------------------------------------
for n = 1:length(G0(:,1,1))
    GMx(n) = 0.1;
    stop = 0;
    while stop == 0;
        G(n,:,:) = G0(n,:,:);
        GMx0 = GMx(n)/3;
        Gstep = squeeze(G(n,1,:));
        G(n,1,abs(Gstep) > GMx0) = sign(Gstep(abs(Gstep) > GMx0))*GMx0;
        Gleft = zeros(3,1);
        Gleft(abs(Gstep) > GMx0) = Gstep(abs(Gstep) > GMx0) - sign(Gstep(abs(Gstep) > GMx0))*GMx0;
        G(n,2,:) = squeeze(G(n,2,:)) + Gleft;
        for m = 2:ind
            Gstep = squeeze(G(n,m,:) - G(n,m-1,:));
            if m == 2
                GMx0 = 2*GMx(n)/3;
            else
                GMx0 = GMx(n);
            end
            G(n,m,abs(Gstep) > GMx0) = sign(Gstep(abs(Gstep) > GMx0))*GMx0 + squeeze(G(n,m-1,abs(Gstep) > GMx0));
            Gleft = zeros(3,1);
            Gleft(abs(Gstep) > GMx0) = Gstep(abs(Gstep) > GMx0) - sign(Gstep(abs(Gstep) > GMx0))*GMx0;
            if sum(Gleft) == 0
                stop = 1;
                break
            end
            G(n,m+1,:) = squeeze(G(n,m+1,:)) + Gleft;
        end
        GMx(n) = GMx(n) + 0.01;
    end
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
plot(cartgsteps(1,:,1),'b'); plot(cartgsteps(1,:,2),'g'); plot(cartgsteps(1,:,3),'r');
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
