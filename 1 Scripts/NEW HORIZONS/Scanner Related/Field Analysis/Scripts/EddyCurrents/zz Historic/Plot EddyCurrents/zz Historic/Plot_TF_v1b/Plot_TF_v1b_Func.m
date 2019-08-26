%==================================================
% 
%==================================================

function [PLOT,err] = Plot_TF_v1b_Func(PLOT,INPUT)

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


TF_expT = EDDY.TF.Data.TF_expT;
TF_Grad = EDDY.TF.Data.TF_Grad;
TF_B01 = EDDY.TF.Data.TF_B01;
TF_B02 = EDDY.TF.Data.TF_B02;

% if length(TF_Grad(:,1)) > 1
%     err.flag = 1;
%     err.msg = 'Use Multiple TF Plotting';
%     return
% end

figure(1000); hold on; 
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_Grad,[clr,'-']);     
ylim([-max(abs(TF_Grad)) max(abs(TF_Grad))]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); xlim([0 max(TF_expT)]); title('Transient Field (Gradient)');

figure(1001); hold on; 
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_B01*1000,[clr,'-']); 
plot(TF_expT,TF_B02*1000,[clr,'-']); 
ylim([-max(abs(TF_B01*1000)) max(abs(TF_B01*1000))]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(TF_expT)]); title('Transient Field (B0)');

outstyle = 0;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end