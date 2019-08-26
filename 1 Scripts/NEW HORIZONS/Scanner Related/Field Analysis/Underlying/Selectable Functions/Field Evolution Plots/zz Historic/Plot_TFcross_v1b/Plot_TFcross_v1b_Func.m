%==================================================
% 
%==================================================

function [PLOT,err] = Plot_TFcross_v1b_Func(PLOT,INPUT)

Status('busy','Plot Transient Fields After Gradient');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EDDY = INPUT.EDDY;
clr = PLOT.clr;
clear INPUT;

%---------------------------------------------
% Get Input
%---------------------------------------------
% Test = EDDY.TF.Data
% figure(100); hold on;
% for n = 1:20
%     plot(Test.TF_PH1(1,:,n));
%     plot(Test.TF_PH2(1,:,n),'r');
% end

% GeddyA = EDDY.GeddyA;
% GeddyB = EDDY.GeddyB;
% Geddy1 = EDDY.Geddy1;
% Geddy2 = EDDY.Geddy2;
% B0eddyA = EDDY.B0eddyA;
% B0eddyB = EDDY.B0eddyB;
% B0eddy1 = EDDY.B0eddy1;
% B0eddy2 = EDDY.B0eddy2;
% GeddyCrossAB = EDDY.GeddyCrossAB;
% GeddyCross12 = EDDY.GeddyCross12;
Time = EDDY.Time;

if strcmp(PLOT.cross,'AB->12')
    Geddy1 = EDDY.GeddyABm12_A;
    Geddy2 = EDDY.GeddyABm12_B;
    %     GeddyA = Geddy1;                        % AB direction eddy at location 1
%     GeddyB = Geddy2;    
%     B0eddyA = B0eddy1;
%     B0eddyB = B0eddy2;   
%     GeddyCross = GeddyCross12;
%     LocA = EDDY.Loc1A;
%     LocB = EDDY.Loc2A;
%     B0eddyRemA = EDDY.B0eddyRemAB1;
%     B0eddyRemB = EDDY.B0eddyRemAB2;
elseif strcmp(PLOT.cross,'12->AB')
    Geddy1 = EDDY.Geddy12mAB_1;
    Geddy2 = EDDY.Geddy12mAB_2;
%     GeddyA = Geddy1;         
%     GeddyCross = GeddyCrossAB;
%     LocA = EDDY.LocA2;
%     LocB = EDDY.LocB2;
%     B0eddyRemA = EDDY.B0eddyRem12a;
%     B0eddyRemB = EDDY.B0eddyRem12b;
end
    
figure(1000); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,Geddy1,'b-');
plot(Time,Geddy2,'r:');
ylim([-max(abs(Geddy1)) max(abs(Geddy1))]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); xlim([0 max(Time)]); title('Transient Field (Gradient)');

figure(1001); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,B0eddyA*1000,'b'); 
plot(Time,B0eddyB*1000,'r'); 
%ylim([-max(abs(B0eddyA*1000)) max(abs(B0eddyB*1000))]);
ylim([-150 150]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(Time)]); title('Transient Field (B0)');
%OutStyle;

figure(1002); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,GeddyCross,clr);
%ylim([-max(abs(GeddyCross)) max(abs(GeddyCross))]);
ylim([-0.5 0.5])
%xlim([0 max(Time)]);
xlim([0 20])
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Cross Transient Field (Gradient)');
OutStyle;

B0eddyRemAtest = B0eddyA - GeddyCross*LocA;
B0eddyRemBtest = B0eddyB - GeddyCross*LocB;

test1 = nansum(B0eddyRemAtest - B0eddyRemA);
test2 = nansum(B0eddyRemBtest - B0eddyRemB);

figure(1003); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,B0eddyRemA*1000,'b'); 
plot(Time,B0eddyRemB*1000,'r:'); 
%ylim([-max(abs(B0eddyRemB*1000)) max(abs(B0eddyRemB*1000))]);
ylim([-150 150]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(Time)]); title('Transient Field (B0)');

%---------------------------------------------
% Get Rid of Probe Dephasing 
%---------------------------------------------
% GeddyCross(isnan(GeddyCross)) = 0;
% GeddyCross = GeddyCross(1:8000);
% ftGeddyCross = fft(GeddyCross);
% figure(1004);
% plot(abs(ftGeddyCross));
% ftGeddyCross(1000:7000) = 0;
% %ftGeddyCross(1:35) = 0;
% %ftGeddyCross(7966:8000) = 0;
% GeddyCross = ifft(ftGeddyCross);
% figure(1005);
% plot(real(GeddyCross),'k');

B0eddyRemA(isnan(B0eddyRemA)) = 0;
%B0eddyRemA = B0eddyRemA(1:8000);
ftB0eddyRemA = fft(B0eddyRemA);
figure(1004);
plot(abs(ftB0eddyRemA));
ftB0eddyRemA(end/20:19*end/20) = 0;
%ftB0eddyRemA(1:35) = 0;
%ftB0eddyRemA(7966:8000) = 0;
B0eddyRemA = ifft(ftB0eddyRemA);
figure(1003);
plot(Time,real(B0eddyRemA)*1000,'k');


function OutStyle
outstyle = 1;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end