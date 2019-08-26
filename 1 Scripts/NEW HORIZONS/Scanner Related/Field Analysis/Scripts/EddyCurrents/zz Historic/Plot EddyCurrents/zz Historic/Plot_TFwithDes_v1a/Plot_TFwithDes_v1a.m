%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_TFwithDes_v1a(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr;
if iscell(clr)
    clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entryvalue};
end
Mat_File = SCRPTipt(strcmp('Mat_File',{SCRPTipt.labelstr})).runfuncoutput{1};

load(Mat_File)
whos
if exist('Input','var')
    Gradient = Input;
end

TF_expT = SCRPTGBL.TF.Data.TF_expT;
TF_Grad = SCRPTGBL.TF.Data.TF_Grad;
TF_B01 = SCRPTGBL.TF.Data.TF_B01;
TF_B02 = SCRPTGBL.TF.Data.TF_B02;

if length(TF_Grad(:,1)) > 1
    err.flag = 1;
    err.msg = 'Use Multiple TF Plotting';
    return
end

figure(1000); hold on; 
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(Gradient.L,Gradient.Gvis,'k');
plot(TF_expT,TF_Grad,[clr,'-']);     
ylim([-max(abs(TF_Grad)) max(abs(TF_Grad))]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); xlim([0 max(TF_expT)]); title('Transient Field (Gradient)');

figure(1001); hold on; 
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(Gradient.L,Gradient.Gvis,'k');
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