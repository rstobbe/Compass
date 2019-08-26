%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_PL_v1a(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr;
if iscell(clr)
    clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entryvalue};
end

PL_expT = SCRPTGBL.PosBG.Data.PL_expT;
PL_Grad = SCRPTGBL.PosBG.Data.PL_Grad;
PL_B01 = SCRPTGBL.PosBG.Data.PL_B01;
PL_B02 = SCRPTGBL.PosBG.Data.PL_B02;
PL_Bloc1 = SCRPTGBL.PosBG.Data.PL_Bloc1; 
PL_Bloc2 = SCRPTGBL.PosBG.Data.PL_Bloc2;
PL_Fid1 = SCRPTGBL.PosBG.Data.PL_Fid1;
PL_Fid2 = SCRPTGBL.PosBG.Data.PL_Fid2;

figure(1000); hold on; 
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,PL_Grad,clr);     
ylim([-max(abs(PL_Grad)) max(abs(PL_Grad))]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); xlim([0 max(PL_expT)]); title('Transient Field (Gradient)');

figure(1001); hold on; 
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,PL_B01*1000,clr); 
plot(PL_expT,PL_B02*1000,clr); 
ylim([-max(abs(PL_B01*1000)) max(abs(PL_B01*1000))]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(PL_expT)]); title('Transient Field (B0)');

figure(1002); hold on; 
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,PL_Bloc1,'r');     
plot(PL_expT,PL_Bloc2,'b');
ylim([-max(abs([PL_Bloc1 PL_Bloc2])) max(abs([PL_Bloc1 PL_Bloc2]))]);
xlabel('(ms)'); ylabel('Field Evolution (mT)'); xlim([0 max(PL_expT)]); title('Transient Fields ');

figure(1003); hold on; 
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,abs(PL_Fid1),[clr,'-']);     
plot(PL_expT,abs(PL_Fid2),[clr,':']);    
ylim([-max(abs(PL_Fid1)) max(abs(PL_Fid1))]);
xlabel('(ms)'); ylabel('Fid Magnitude'); xlim([0 max(PL_expT)]); title('Fid Magnitude');

outstyle = 0;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end