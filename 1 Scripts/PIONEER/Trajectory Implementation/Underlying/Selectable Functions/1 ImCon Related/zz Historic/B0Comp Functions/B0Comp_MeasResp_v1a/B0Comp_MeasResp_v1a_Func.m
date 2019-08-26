%=====================================================
% 
%=====================================================

function [B0COMP,err] = B0Comp_MeasResp_v1a_Func(B0COMP,INPUT)

Status2('busy','Compensate for Measured B0 Response',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
samp = INPUT.samp;
PROJimp = INPUT.PROJimp;
TGSR0 = INPUT.TGSR;
GSR0 = INPUT.GSR;
clear INPUT

%---------------------------------------------
% Get Variables
%---------------------------------------------
gamma = PROJimp.gamma;

%---------------------------------------------
% Interpolate
%---------------------------------------------
Tstep = (TGSR0(2) - TGSR0(1))*12;
TGSR = (0:Tstep:TGSR0(length(TGSR0)));
GSR0 = permute(GSR0,[2 1 3]);
GSR = interp1(TGSR0,GSR0,TGSR);
GSR = permute(GSR,[2 1 3]);

%---------------------------------------------
% Get B0 Response
%---------------------------------------------
TB0 = B0COMP.B0Resp.B0RESP.Time;
B0 = B0COMP.B0Resp.B0RESP.B0;
[nproj,M,~] = size(GSR);

%*************
%B0 = 0.1*ones(size(B0));
%B0 = 10*ones(size(B0));                 % yeilds a position shift...
%*************
%B0 = permute(B0,[2 1]);
%B0 = cat(2,B0,B0,B0);   % will be different for each direction
%*************
B0X = -0.367*exp(-TB0/0.464);
B0Y = 0.380*exp(-TB0/0.183);
B0Z = 0.925*exp(-TB0/0.032);
B0X = B0X*100;
B0Y = B0Y*100;
B0Z = B0Z*100;
figure(2900); hold on;
plot(TB0,B0X); plot(TB0,B0Y); plot(TB0,B0Z);
B0X = permute(B0X,[2 1]);
B0Y = permute(B0Y,[2 1]);
B0Z = permute(B0Z,[2 1]);
B0 = cat(2,B0X,B0Y,B0Z);

%---------------------------------------------
% Find B0 Values along trajectory
%---------------------------------------------
Status2('busy','Interpolate B0 Response at GWFM Locations',2);
iB0 = interp1(TB0,B0,TGSR,'cubic','extrap');

%---------------------------------------------
% Find B0 Values along trajectory
%---------------------------------------------
Status2('busy','Calculate B0 Response',2);
m = (2:M);
steps = GSR(:,m,:)-GSR(:,m-1,:);
steps = [GSR(:,1,:) steps];
TrajB0X = zeros(nproj,M);
TrajB0Y = zeros(nproj,M);
TrajB0Z = zeros(nproj,M);
iB0 = permute(iB0,[2 1]);
for m = 1:M
    TrajB0X(:,m:M) = steps(:,m,1)*iB0(1,1:M-m+1) + TrajB0X(:,m:M);
    TrajB0Y(:,m:M) = steps(:,m,2)*iB0(2,1:M-m+1) + TrajB0Y(:,m:M);
    TrajB0Z(:,m:M) = steps(:,m,3)*iB0(3,1:M-m+1) + TrajB0Z(:,m:M);
    %figure(3001);
    %clf(3001);
    %figure(3001); hold on;
    %plot(TGSR,TrajB0(5,:),'k');
    %plot(TGSR(m),TrajB0(5,m),'r*');
    %plot(TGSR(1:m),TrajB0(5,1:m),'r');
    %figure(3002); hold on;
    %plot(TGSR(m:M),steps(:,m,3)*iB0(1:M-m+1),'b');
    Status2('busy',['GWFM countdown: ',num2str(M-m)],3);
end
Status2('done','',3); 

TrajB0 = TrajB0X + TrajB0Y + TrajB0Z;

%---------------------------------------------
% Plot
%---------------------------------------------
%figure(2999); hold on;
%plot(TGSR,iB0,'k');
figure(3000); hold on;
plot(TGSR,TrajB0(1,:),'k');
xlabel('ms'); ylabel('B0 (uT)'); title('traj1');
figure(3001); hold on;
plot(TGSR,TrajB0(5,:),'k');
xlabel('ms'); ylabel('B0 (uT)'); title('traj5');
figure(3002); hold on;
plot(TGSR,TrajB0(19,:),'k');
xlabel('ms'); ylabel('B0 (uT)'); title('traj19');

%---------------------------------------------
% Phase Evolution
%---------------------------------------------
Status2('busy','Calculate Phase Evolution',2);
%Phase = ones(nproj,M);
Phase = zeros(nproj,M);
for m = 2:M
    meanB0 = mean([TrajB0(:,m-1) TrajB0(:,m)],2);
    %Phase(:,m) = Phase(:,m-1).*exp(1i*2*pi*gamma*Tstep*meanB0);
    Phase(:,m) = Phase(:,m-1) + (2*pi*gamma*(Tstep/1000)*meanB0);
end
figure(4000); hold on;
plot(TGSR,Phase(1,:),'k');
%plot(TGSR,angle(Phase(1,:)),'k');
figure(4001); hold on;
plot(TGSR,Phase(5,:),'k');
%plot(TGSR,angle(Phase(5,:)),'k');
figure(4002); hold on;
plot(TGSR,Phase(19,:),'k');
%plot(TGSR,angle(Phase(19,:)),'k');

%---------------------------------------------
% Interpolate Phase Evolution at Sampling Timing
%---------------------------------------------
Phase = permute(Phase,[2 1]);
PhaseB0 = interp1(TGSR,Phase,samp);
PhaseB0 = permute(PhaseB0,[2 1]);
figure(4000); hold on;
plot(samp,PhaseB0(1,:),'r*');
%plot(samp,angle(PhaseB0(1,:)),'r*');
xlabel('ms'); ylabel('phase (rad)'); title('traj1');
figure(4001); hold on;
plot(samp,PhaseB0(5,:),'r*');
%plot(samp,angle(PhaseB0(5,:)),'r*');
xlabel('ms'); ylabel('phase (rad)'); title('traj5');
figure(4002); hold on;
plot(samp,PhaseB0(19,:),'r*')
%plot(samp,angle(PhaseB0(19,:)),'r*');
xlabel('ms'); ylabel('phase (rad)'); title('traj19');

%---------------------------------------------
% Return
%---------------------------------------------
B0COMP.TrajB0 = TrajB0;
B0COMP.PhaseB0 = PhaseB0;

Status2('done','',2);
Status2('done','',3);


    
    