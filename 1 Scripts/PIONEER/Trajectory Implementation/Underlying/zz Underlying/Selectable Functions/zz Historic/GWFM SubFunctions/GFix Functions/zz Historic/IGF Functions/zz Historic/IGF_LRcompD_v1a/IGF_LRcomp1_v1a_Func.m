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
% Max Grad Step
%---------------------------------------------
%iorthslp = [(50:10:160) 160*ones(1,10)];
%gstepdur = GQNT.gseg;
%GMx = iorthslp*gstepdur;

%----------------------------------------------------
% Steps
%----------------------------------------------------
%m = (2:length(G0(1,:,1))-2);
%initsteps = G0(:,1,:);
%vecinitstep = sqrt(initsteps(:,:,1).^2 + initsteps(:,:,2).^2 + initsteps(:,:,3).^2);
%cartgsteps = G0(:,m,:)-G0(:,m-1,:);
%vecgsteps = sqrt(cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2);
%vecgsteps = [vecinitstep vecgsteps];
%figure(1101);
%plot(vecgsteps(1,:));
%xlabel('Trajectory Step Number','fontsize',10,'fontweight','bold');
%ylabel('Gradient Step (mT/m)','fontsize',10,'fontweight','bold');

%---------------------------------------------
% Fix
%---------------------------------------------

for n = 1:length(G(:,1,1))
    GMx(n) = 0.1;
    stop = 0;
    while stop == 0;
        G = G0;
        Gstep = squeeze(G(n,1,:));
        G(n,1,abs(Gstep) > GMx(n)) = sign(Gstep(abs(Gstep) > GMx(n)))*GMx(n);
        Gleft = zeros(3,1);
        Gleft(abs(Gstep) > GMx(n)) = Gstep(abs(Gstep) > GMx(n)) - sign(Gstep(abs(Gstep) > GMx(n)))*GMx(n);
        G(n,2,:) = squeeze(G(n,2,:)) + Gleft;
        for m = 2:10
            Gstep = squeeze(G(n,m,:) - G(n,m-1,:));
            G(n,m,abs(Gstep) > GMx(n)) = sign(Gstep(abs(Gstep) > GMx(n)))*GMx(n) + squeeze(G(n,m-1,abs(Gstep) > GMx(n)));
            Gleft = zeros(3,1);
            Gleft(abs(Gstep) > GMx(n)) = Gstep(abs(Gstep) > GMx(n)) - sign(Gstep(abs(Gstep) > GMx(n)))*GMx(n);
            if sum(Gleft) == 0
                stop = 1;
                break
            end
            G(n,m+1,:) = squeeze(G(n,m+1,:)) + Gleft;
        end
        GMx(n) = GMx(n) + 0.01;
    end
end

%----------------------------------------------------
% Steps
%----------------------------------------------------
m = (2:length(G(1,:,1))-2);
initsteps = G(:,1,:);
vecinitstep = sqrt(initsteps(:,:,1).^2 + initsteps(:,:,2).^2 + initsteps(:,:,3).^2);
cartgsteps = G(:,m,:)-G(:,m-1,:);
vecgsteps = sqrt(cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2);
vecgsteps = [vecinitstep vecgsteps];
figure(1101);
plot(vecgsteps(1,:));
xlabel('Trajectory Step Number','fontsize',10,'fontweight','bold');
ylabel('Gradient Step (mT/m)','fontsize',10,'fontweight','bold');

%---------------------------------------------
% Return
%---------------------------------------------
IGF.G0fix = G;

Status2('done','',2);
Status2('done','',3);
