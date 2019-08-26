%==================================================
% 
%==================================================

function [PLOT,err] = Plot_MultiTransientField_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Multi Transient Field',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MFEVO = INPUT.MFEVO;
clear INPUT;

%-----------------------------------------------------
% Load Data
%-----------------------------------------------------
TF_expT = MFEVO.TF.Data.TF_expT;
TF_Grad = MFEVO.TF.Data.TF_Grad(PLOT.acqnum,:,PLOT.transnum);
TF_B01 = MFEVO.TF.Data.TF_B01(PLOT.acqnum,:,PLOT.transnum);
TF_B02 = MFEVO.TF.Data.TF_B02(PLOT.acqnum,:,PLOT.transnum);
TF_Bloc1 = MFEVO.TF.Data.TF_Bloc1(PLOT.acqnum,:,PLOT.transnum);
TF_Bloc2 = MFEVO.TF.Data.TF_Bloc2(PLOT.acqnum,:,PLOT.transnum);
TF_smthBloc1 = MFEVO.TF.Data.TF_smthBloc1(PLOT.acqnum,:,PLOT.transnum);
TF_smthBloc2 = MFEVO.TF.Data.TF_smthBloc2(PLOT.acqnum,:,PLOT.transnum);
corTF_Bloc1 = MFEVO.TF.Data.corTF_Bloc1(PLOT.acqnum,:,PLOT.transnum);
corTF_Bloc2 = MFEVO.TF.Data.corTF_Bloc2(PLOT.acqnum,:,PLOT.transnum); 
TF_PH1 = MFEVO.TF.Data.TF_PH1(PLOT.acqnum,:,PLOT.transnum);
TF_PH2 = MFEVO.TF.Data.TF_PH2(PLOT.acqnum,:,PLOT.transnum);
TF_Fid1 = MFEVO.TF.Data.TF_Fid1(PLOT.acqnum,:,PLOT.transnum);
TF_Fid2 = MFEVO.TF.Data.TF_Fid2(PLOT.acqnum,:,PLOT.transnum);

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(1001); 
clr = 'k';

subplot(2,4,1); hold on;
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,abs(TF_Fid1),'r-');
plot(TF_expT,abs(TF_Fid2),'b-');  
ylim([-max(abs([TF_Fid1 TF_Fid2])) max(abs([TF_Fid1 TF_Fid2]))]);
xlabel('(ms)'); ylabel('FID Magnitude (arb)'); xlim([0 max(TF_expT)]); title('FID Decay');

subplot(2,4,2); hold on;
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_PH1,'r-');     
plot(TF_expT,TF_PH2,'b-'); 
ylim([-max(abs([TF_PH1 TF_PH2])) max(abs([TF_PH1 TF_PH2]))]);
xlabel('(ms)'); ylabel('Phase Evolution (rads)'); xlim([0 max(TF_expT)]); title('Transient Phase');

subplot(2,4,3); hold on;
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_Bloc1*1000,'r');
plot(TF_expT,TF_Bloc2*1000,'b'); 
ylim([-max(abs([TF_Bloc1 TF_Bloc2]*1000)) max(abs([TF_Bloc1 TF_Bloc2]*1000))]);
xlabel('(ms)'); ylabel('Field Evolution (uT)'); xlim([0 max(TF_expT)]); title('Transient Fields');

subplot(2,4,4); hold on;
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_smthBloc1*1000,'r');
plot(TF_expT,TF_smthBloc2*1000,'b'); 
ylim([-max(abs([TF_smthBloc1 TF_smthBloc2]*1000)) max(abs([TF_smthBloc1 TF_smthBloc2]*1000))]);
xlabel('(ms)'); ylabel('Field Evolution (uT)'); xlim([0 max(TF_expT)]); title('Smoothed Transient Fields');

subplot(2,4,5); hold on;
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,corTF_Bloc1*1000,'r');
plot(TF_expT,corTF_Bloc2*1000,'b');
ylim([-max(abs([TF_Bloc1 TF_Bloc2]*1000)) max(abs([TF_Bloc1 TF_Bloc2]*1000))]);
xlabel('(ms)'); ylabel('Field Evolution (uT)'); xlim([0 max(TF_expT)]); title('Background Corrected Transient Fields');

subplot(2,4,6); hold on;
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_Grad*1000,clr);
ylim([-max(abs(TF_Grad*1000)) max(abs(TF_Grad*1000))]);
xlabel('(ms)'); ylabel('Gradient Evolution (uT/m)'); xlim([0 max(TF_expT)]); title('Transient Field (Gradient)');

subplot(2,4,7); hold on;
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_B01*1000,clr); 
plot(TF_expT,TF_B02*1000,clr); 
ylim([-max(abs(TF_B01*1000)) max(abs(TF_B01*1000))]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(TF_expT)]); title('Transient Field (B0)');


set(gcf,'units','inches');
set(gcf,'position',[3 1 14 8]);


Status2('done','',2);
Status2('done','',3);