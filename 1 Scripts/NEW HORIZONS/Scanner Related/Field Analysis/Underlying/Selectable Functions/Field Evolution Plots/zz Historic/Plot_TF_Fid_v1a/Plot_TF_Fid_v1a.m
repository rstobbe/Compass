%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_TF_Fid_v1a(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr;
if iscell(clr)
    clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entryvalue};
end

TF_expT = SCRPTGBL.TF.Data.TF_expT;
TF_Fid1 = SCRPTGBL.TF.Data.TF_Fid1;
TF_Fid2 = SCRPTGBL.TF.Data.TF_Fid2;

if length(TF_Fid1(:,1)) > 1
    err.flag = 1;
    err.msg = 'Use Multiple TF Plotting';
    return
end

figure(1000); hold on; 
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,abs(TF_Fid1),[clr,'-']);     
plot(TF_expT,abs(TF_Fid2),[clr,':']);    
ylim([-max(abs(TF_Fid1)) max(abs(TF_Fid1))]);
xlabel('(ms)'); ylabel('Fid Magnitude'); xlim([0 max(TF_expT)]); title('Fid Magnitude');


outstyle = 0;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end