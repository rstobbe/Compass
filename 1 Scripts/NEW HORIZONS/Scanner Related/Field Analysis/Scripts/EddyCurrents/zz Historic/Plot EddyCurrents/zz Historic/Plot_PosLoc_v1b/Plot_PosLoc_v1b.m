%==================================================
% (v1b)
%       - update for RWSUI_BA
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_PosLoc_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Plot Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get EDDY Currents
%---------------------------------------------
global TOTALGBL
% val = get(findobj('tag','totalgbl'),'value');
% if isempty(val) || val == 0
%     err.flag = 1;
%     err.msg = 'No EDDY in Global Memory';
%     return  
% end
val = 3;
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
PL_expT = EDDY.POSBG.Data.PL_expT;
PL_Grad = EDDY.POSBG.Data.PL_Grad;
PL_B01 = EDDY.POSBG.Data.PL_B01;
PL_B02 = EDDY.POSBG.Data.PL_B02;
PL_Bloc1 = EDDY.POSBG.Data.PL_Bloc1;
PL_Bloc2 = EDDY.POSBG.Data.PL_Bloc2;
PL_PH1 = EDDY.POSBG.Data.PL_PH1;
PL_PH2 = EDDY.POSBG.Data.PL_PH2;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(1000); hold on; 
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,PL_Grad*1000,clr);     
ylim([-max(abs(PL_Grad*1000)) max(abs(PL_Grad*1000))]);
xlabel('(ms)'); ylabel('Gradient Evolution (uT/m)'); xlim([0 max(PL_expT)]); title('Transient Field (Gradient)');

figure(1001); hold on; 
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,PL_B01*1000,clr); 
plot(PL_expT,PL_B02*1000,clr); 
ylim([-max(abs(PL_B01*1000)) max(abs(PL_B01*1000))]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(PL_expT)]); title('Transient Field (B0)');

figure(1002); hold on; 
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,PL_Bloc1*1000,'r');     
plot(PL_expT,PL_Bloc2*1000,'b'); 
ylim([-max(abs([PL_Bloc1 PL_Bloc2]*1000)) max(abs([PL_Bloc1 PL_Bloc2]*1000))]);
xlabel('(ms)'); ylabel('Field Evolution (uT)'); xlim([0 max(PL_expT)]); title('Transient Field');

figure(1003); hold on; 
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,PL_PH1,'r-');     
plot(PL_expT,PL_PH2,'b-'); 
ylim([-max(abs([PL_PH1 PL_PH2])) max(abs([PL_PH1 PL_PH2]))]);
xlabel('(ms)'); ylabel('Phase Evolution (rads)'); xlim([0 max(PL_expT)]); title('Transient Phase');


outstyle = 0;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end