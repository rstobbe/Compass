%==================================================
% (v1b)
%       - update for RWSUI_BA
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_RFPreGradSubInfo_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Plot Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get EDDY Currents
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No EDDY in Global Memory';
    return  
end
EDDY = TOTALGBL{2,val};

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
clr = SCRPTGBL.CurrentTree.('Colour');

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
set(findobj('tag','TestBox'),'string',EDDY.ExpDisp);

%-----------------------------------------------------
% Load Data
%-----------------------------------------------------
TF_expT = EDDY.TF.Data.TF_expT;
TF_Grad = EDDY.TF.Data.TF_Grad;
TF_B01 = EDDY.TF.Data.TF_B01;
TF_B02 = EDDY.TF.Data.TF_B02;
TF_Bloc1 = EDDY.TF.Data.TF_Bloc1;
TF_Bloc2 = EDDY.TF.Data.TF_Bloc2;
corTF_Bloc1 = EDDY.TF.Data.corTF_Bloc1;
corTF_Bloc2 = EDDY.TF.Data.corTF_Bloc2;
TF_PH1 = EDDY.TF.Data.TF_PH1;
TF_PH2 = EDDY.TF.Data.TF_PH2;
TF_PH1steps = EDDY.TF.Data.TF_PH1steps;
TF_PH2steps = EDDY.TF.Data.TF_PH2steps;
TF_Fid1 = EDDY.TF.Data.TF_Fid1;
TF_Fid2 = EDDY.TF.Data.TF_Fid2;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
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
plot(TF_expT,TF_Bloc1*1000,'r:');     
plot(TF_expT,TF_Bloc2*1000,'b:'); 
plot(TF_expT,corTF_Bloc1*1000,'r');     
plot(TF_expT,corTF_Bloc2*1000,'b');
ylim([-max(abs([TF_Bloc1 TF_Bloc2]*1000)) max(abs([TF_Bloc1 TF_Bloc2]*1000))]);
xlabel('(ms)'); ylabel('Field Evolution (uT)'); xlim([0 max(TF_expT)]); title('Transient Field');

figure(1003); hold on; 
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_PH1,'r-');     
plot(TF_expT,TF_PH2,'b-'); 
ylim([-max(abs([TF_PH1 TF_PH2])) max(abs([TF_PH1 TF_PH2]))]);
xlabel('(ms)'); ylabel('Phase Evolution (rads)'); xlim([0 max(TF_expT)]); title('Transient Phase');

figure(1004); hold on; 
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,abs(TF_PH1steps),'r-');     
plot(TF_expT,abs(TF_PH2steps),'b-'); 
ylim([0 3.14]);
xlabel('(ms)'); ylabel('Phase Evolution Steps (rads)'); xlim([0 max(TF_expT)]); title('Transient Phase');

figure(1005); hold on; 
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,abs(TF_Fid1),'r-');     
plot(TF_expT,abs(TF_Fid2),'b-'); 
ylim([-max(abs([TF_Fid1 TF_Fid2])) max(abs([TF_Fid1 TF_Fid2]))]);
xlabel('(ms)'); ylabel('Fid Magnitude'); xlim([0 max(TF_expT)]); title('Transient Fid Magnitude');

outstyle = 0;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end