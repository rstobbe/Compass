%==================================================
% 
%==================================================

function [PLOT,err] = Plot_PosLoc_v1c_Func(PLOT,INPUT)

Status2('busy','Plot Position Locator Data',2);
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
if not(isfield(MFEVO,'POSBG'))
    err.flag = 1;
    err.msg = 'Probe position and background fields not calculated';
    return
end
    
PL_expT = MFEVO.POSBG.Data.PL_expT;
PL_Grad = MFEVO.POSBG.Data.PL_Grad;
PL_B01 = MFEVO.POSBG.Data.PL_B01;
PL_B02 = MFEVO.POSBG.Data.PL_B02;
PL_Bloc1 = MFEVO.POSBG.Data.PL_Bloc1;
PL_Bloc2 = MFEVO.POSBG.Data.PL_Bloc2;
PL_PH1 = MFEVO.POSBG.Data.PL_PH1;
PL_PH2 = MFEVO.POSBG.Data.PL_PH2;

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
plot(PL_expT,PL_Grad,clr);     
ylim([-max(abs(PL_Grad)) max(abs(PL_Grad))]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); xlim([0 max(PL_expT)]); title('Transient Field (Gradient)');

subplot(2,2,4); hold on;
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,PL_B01*1000,clr); 
plot(PL_expT,PL_B02*1000,clr); 
ylim([-max(abs(PL_B01*1000)) max(abs(PL_B01*1000))]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(PL_expT)]); title('Transient Field (B0)');


set(gcf,'units','inches');
set(gcf,'position',[5 1 10 8]);

Status2('done','',2);
Status2('done','',3);

