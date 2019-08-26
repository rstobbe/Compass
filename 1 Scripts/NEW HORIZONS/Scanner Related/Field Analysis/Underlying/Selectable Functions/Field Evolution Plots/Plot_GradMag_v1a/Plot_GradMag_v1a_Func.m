%==================================================
% 
%==================================================

function [PLOT,err] = Plot_GradMag_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Gradient Magnitude Data',2);
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
if not(isfield(MFEVO,'GMAG'))
    err.flag = 1;
    err.msg = 'Gradient magnitude not calculated';
    return
end
    
PL_expT = MFEVO.GMAG.Data.PL_expT;
BG_expT = MFEVO.GMAG.Data.BG_expT;
PL_Bloc1 = MFEVO.GMAG.Data.PL_Bloc1;
PL_Bloc2 = MFEVO.GMAG.Data.PL_Bloc2;
PL_PH1 = MFEVO.GMAG.Data.PL_PH1;
PL_PH2 = MFEVO.GMAG.Data.PL_PH2;
PL_Fid1 = MFEVO.GMAG.Data.PL_Fid1;
PL_Fid2 = MFEVO.GMAG.Data.PL_Fid2;
BG_Fid1 = MFEVO.GMAG.Data.BG_Fid1;
BG_Fid2 = MFEVO.GMAG.Data.BG_Fid2;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(1001); 
clr = 'k';

subplot(2,2,1); hold on;
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,PL_PH1,'r-');     
plot(PL_expT,PL_PH2,'b-'); 
ylim([-max(abs([PL_PH1 PL_PH2])) max(abs([PL_PH1 PL_PH2]))]);
xlabel('(ms)'); ylabel('Phase Evolution (rads)'); xlim([0 max(PL_expT)]); title('Transient Phase');

subplot(2,2,2); hold on;
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,PL_Bloc1*1000,'r');     
plot(PL_expT,PL_Bloc2*1000,'b'); 
ylim([-max(abs([PL_Bloc1 PL_Bloc2]*1000)) max(abs([PL_Bloc1 PL_Bloc2]*1000))]);
xlabel('(ms)'); ylabel('Field Evolution (uT)'); xlim([0 max(PL_expT)]); title('Transient Fields');

subplot(2,2,3); hold on;
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,abs(PL_Fid1),'r');     
plot(PL_expT,abs(PL_Fid2),'b'); 
xlabel('(ms)'); ylabel('Fid Magnitude (arb)'); xlim([0 max(PL_expT)]); title('PosLoc Fid');

subplot(2,2,4); hold on;
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,abs(BG_Fid1),'r');     
plot(BG_expT,abs(BG_Fid2),'b'); 
xlabel('(ms)'); ylabel('Fid Magnitude (arb)'); xlim([0 max(BG_expT)]); title('Background Fid');

set(gcf,'units','inches');
set(gcf,'position',[5 1 10 8]);

Status2('done','',2);
Status2('done','',3);

