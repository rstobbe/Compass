%==================================================
% (v1b)
%       - update for RWSUI_BA
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_BG_v1b(SCRPTipt,SCRPTGBL)

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
BG_expT = EDDY.POSBG.Data.BG_expT;
BG_Grad = EDDY.POSBG.Data.BG_Grad;
BG_B01 = EDDY.POSBG.Data.BG_B01;
BG_B02 = EDDY.POSBG.Data.BG_B02;
BG_Bloc1 = EDDY.POSBG.Data.BG_Bloc1;
BG_Bloc2 = EDDY.POSBG.Data.BG_Bloc2;
BG_smthBloc1 = EDDY.POSBG.BG_smthBloc1;
BG_smthBloc2 = EDDY.POSBG.BG_smthBloc2;
BG_PH1 = EDDY.POSBG.Data.BG_PH1;
BG_PH2 = EDDY.POSBG.Data.BG_PH2;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
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