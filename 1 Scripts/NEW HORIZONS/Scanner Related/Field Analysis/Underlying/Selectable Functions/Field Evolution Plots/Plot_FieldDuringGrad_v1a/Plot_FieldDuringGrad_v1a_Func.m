%==================================================
% 
%==================================================

function [PLOT,err] = Plot_FieldDuringGrad_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Field Evolution During Gradient',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MFEVO = INPUT.MFEVO;
FEVOL = MFEVO.FEVOL;
SysTest = FEVOL.SysTest;
IMP = SysTest.IMP;
GWFM = IMP.GWFM;
clr = PLOT.colour;
clear INPUT;

%-----------------------------------------------------
% Load Data
%-----------------------------------------------------
TF_Bloc1 = MFEVO.TF.Data.TF_Bloc1;
TF_Bloc2 = MFEVO.TF.Data.TF_Bloc2;

%---------------------------------------------
% Get Input
%---------------------------------------------
figure(2000); 
subplot(1,1,1); hold on; 
plot([0 max(MFEVO.Time)],[0 0],'k:'); 
plot(GWFM.L,GWFM.Gvis(GWFM.Dir,:),'k','linewidth',1);
plot(MFEVO.Time,MFEVO.GradField,clr);     
ylim([-max(abs(MFEVO.GradField)) max(abs(MFEVO.GradField))]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); xlim([0 max(MFEVO.Time)]); title('Transient Field (Gradient)');

% subplot(2,1,2); hold on; 
% plot([0 max(MFEVO.Time)],[0 0],'k:'); 
% plot(MFEVO.Time,MFEVO.B0Field*1000,clr);  
% ylim([-max(abs(MFEVO.B0Field*1000)) max(abs(MFEVO.B0Field*1000))]);
% xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(MFEVO.Time)]); title('Transient Field (B0)');

% subplot(2,2,3); hold on; 
% plot([0 max(MFEVO.Time)],[0 0],'k:'); 
% plot(MFEVO.Time,TF_Bloc1*1000,'r');
% plot(MFEVO.Time,TF_Bloc2*1000,'b');
% ylim([-max(abs([TF_Bloc1 TF_Bloc2]*1000)) max(abs([TF_Bloc1 TF_Bloc2]*1000))]);
% xlabel('(ms)'); ylabel('Field Evolution (uT)'); xlim([0 max(MFEVO.Time)]); title('Transient Field');

% test = fft(MFEVO.GradField);
% figure(2000); hold on;
% plot(abs(test));
% test(600:5400) = 0;
% plot(abs(test));
% test = ifft(test);
% figure(1001);
% plot(MFEVO.Time,test,'m'); 

% outstyle = 0;
% if outstyle == 1
%     set(gcf,'units','inches');
%     set(gcf,'position',[4 4 4 4]);
%     set(gcf,'paperpositionmode','auto');
%     set(gca,'units','inches');
%     set(gca,'position',[0.75 0.5 2.5 2.5]);
%     set(gca,'fontsize',10,'fontweight','bold');
% end

Status2('done','',2);
Status2('done','',3);