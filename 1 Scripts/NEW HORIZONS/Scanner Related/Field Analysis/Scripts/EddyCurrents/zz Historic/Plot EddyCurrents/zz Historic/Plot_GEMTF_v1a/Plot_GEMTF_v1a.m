%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_GEMTF_v1a(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr;
if iscell(clr)
    clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entryvalue};
end
expnum = str2double(SCRPTipt(strcmp('Exp Number',{SCRPTipt.labelstr})).entrystr);
acqnum = str2double(SCRPTipt(strcmp('Acq Number',{SCRPTipt.labelstr})).entrystr);

TF_expT = SCRPTGBL.TF.Data.TF_expT;
TF_Grad = SCRPTGBL.TF.Data.TF_Grad(expnum,:,acqnum);
TF_B01 = SCRPTGBL.TF.Data.TF_B01(expnum,:,acqnum);
TF_B02 = SCRPTGBL.TF.Data.TF_B02(expnum,:,acqnum);
TF_Bloc1 = SCRPTGBL.TF.Data.TF_Bloc1(expnum,:,acqnum);
TF_Bloc2 = SCRPTGBL.TF.Data.TF_Bloc2(expnum,:,acqnum);

figure(1000); hold on; 
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_Grad*1000,clr);     
ylim([-max(abs(TF_Grad*1000)) max(abs(TF_Grad*1000))]);
xlabel('(ms)'); ylabel('Gradient Evolution (uT/m)'); xlim([0 max(TF_expT)]); title('Transient Field (Gradient)');

figure(1001); hold on; 
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_B01*1000,clr); 
plot(TF_expT,TF_B02*1000,clr); 
ylim([-max(abs(TF_B01*1000)) max(abs(TF_B01*1000))]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(TF_expT)]); title('Transient Field (B0)');

figure(1002); hold on; 
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_Bloc1*1000,'r');     
plot(TF_expT,TF_Bloc2*1000,'b'); 
ylim([-max(abs([TF_Bloc1 TF_Bloc2]*1000)) max(abs([TF_Bloc1 TF_Bloc2]*1000))]);
xlabel('(ms)'); ylabel('Field Evolution (uT)'); xlim([0 max(TF_expT)]); title('Transient Field');

outstyle = 0;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end