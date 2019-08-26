%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_BG_v1a(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr;
if iscell(clr)
    clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entryvalue};
end

BG_expT = SCRPTGBL.PosBG.Data.BG_expT;
BG_Grad = SCRPTGBL.PosBG.Data.BG_Grad;
BG_B01 = SCRPTGBL.PosBG.Data.BG_B01;
BG_B02 = SCRPTGBL.PosBG.Data.BG_B02;
BG_Bloc1 = SCRPTGBL.PosBG.Data.BG_Bloc1;
BG_Bloc2 = SCRPTGBL.PosBG.Data.BG_Bloc2;
BG_smthBloc1 = SCRPTGBL.PosBG.BG_smthBloc1;
BG_smthBloc2 = SCRPTGBL.PosBG.BG_smthBloc2;
BG_PH1 = SCRPTGBL.PosBG.Data.BG_PH1;
BG_PH2 = SCRPTGBL.PosBG.Data.BG_PH2;

figure(1000); hold on; 
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,BG_Grad*1000,clr);     
ylim([-max(abs(BG_Grad*1000)) max(abs(BG_Grad*1000))]);
xlabel('(ms)'); ylabel('Gradient Evolution (uT/m)'); xlim([0 max(BG_expT)]); title('Transient Field (Gradient)');

figure(1001); hold on; 
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,BG_B01*1000,clr); 
plot(BG_expT,BG_B02*1000,clr); 
ylim([-max(abs(BG_B01*1000)) max(abs(BG_B01*1000))]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(BG_expT)]); title('Transient Field (B0)');

figure(1002); hold on; 
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,BG_Bloc1*1000,'r');     
plot(BG_expT,BG_Bloc2*1000,'b'); 
plot(BG_expT,BG_smthBloc1*1000,'r:');     
plot(BG_expT,BG_smthBloc2*1000,'b:');
ylim([-max(abs([BG_Bloc1 BG_Bloc2]*1000)) max(abs([BG_Bloc1 BG_Bloc2]*1000))]);
xlabel('(ms)'); ylabel('Field Evolution (uT)'); xlim([0 max(BG_expT)]); title('Transient Field');

figure(1003); hold on; 
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,BG_PH1,'r-');     
plot(BG_expT,BG_PH2,'b-'); 
ylim([-max(abs([BG_PH1 BG_PH2])) max(abs([BG_PH1 BG_PH2]))]);
xlabel('(ms)'); ylabel('Phase Evolution (rads)'); xlim([0 max(BG_expT)]); title('Transient Phase');

test = BG_PH1 - circshift(BG_PH1,[0 -1]);
maxPHstep1 = max(abs(test(1:length(test)-1)))
test2 = BG_PH2 - circshift(BG_PH2,[0 -1]);
maxPHstep2 = max(abs(test2(1:length(test2)-1)))

outstyle = 0;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end