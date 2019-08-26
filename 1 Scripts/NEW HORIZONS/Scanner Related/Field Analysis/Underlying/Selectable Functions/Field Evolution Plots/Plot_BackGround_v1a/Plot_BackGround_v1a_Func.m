%==================================================
% 
%==================================================

function [PLOT,err] = Plot_BackGround_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Background Field',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MFEVO = INPUT.MFEVO;
clear INPUT;

field = '';
if isfield(MFEVO,'POSBG')
    field = 'POSBG';
end
if isempty(field)
    err.flag = 1;
    err.msg = 'File does not contain a ''Background'' measurement';
    return
end

%-----------------------------------------------------
% Load Data
%-----------------------------------------------------
BG_expT = MFEVO.(field).Data.BG_expT;
BG_Grad = MFEVO.(field).Data.BG_Grad;
BG_smthGrad = MFEVO.(field).Data.BG_smthGrad;
BG_B01 = MFEVO.(field).Data.BG_B01;
%BG_B02 = MFEVO.(field).Data.BG_B02;                        % should be identical to BG_B02
BG_Bloc1 = MFEVO.(field).Data.BG_Bloc1;
BG_Bloc2 = MFEVO.(field).Data.BG_Bloc2;
BG_smthBloc1 = MFEVO.(field).BG_smthBloc1;
BG_smthBloc2 = MFEVO.(field).BG_smthBloc2; 
BG_PH1 = MFEVO.(field).Data.BG_PH1;
BG_PH2 = MFEVO.(field).Data.BG_PH2;
BG_Fid1 = MFEVO.(field).Data.BG_Fid1;
BG_Fid2 = MFEVO.(field).Data.BG_Fid2;
BG_smthB01 = MFEVO.(field).Data.BG_smthB01; 

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(1000); 
clr = 'g';

subplot(2,3,1); hold on;
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,abs(BG_Fid1),'r-');
plot(BG_expT,abs(BG_Fid2),'b-');  
ylim([-max(abs([BG_Fid1 BG_Fid2])) max(abs([BG_Fid1 BG_Fid2]))]);
xlabel('(ms)'); ylabel('FID Magnitude (arb)'); xlim([0 max(BG_expT)]); title('FID Decay');

subplot(2,3,2); hold on;
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,BG_PH1,'r-');     
plot(BG_expT,BG_PH2,'b-'); 
ylim([-max(abs([BG_PH1 BG_PH2])) max(abs([BG_PH1 BG_PH2]))]);
xlabel('(ms)'); ylabel('Phase Evolution (rads)'); xlim([0 max(BG_expT)]); title('Transient Phase');

subplot(2,3,3); hold on;
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,BG_Bloc1*1000,'r');
plot(BG_expT,BG_Bloc2*1000,'b'); 
ylim([-max(abs([BG_Bloc1 BG_Bloc2]*1000)) max(abs([BG_Bloc1 BG_Bloc2]*1000))]);
xlabel('(ms)'); ylabel('Field Evolution (uT)'); xlim([0 max(BG_expT)]); title('Transient Fields');

subplot(2,3,4); hold on;
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,BG_smthBloc1*1000,'r');
plot(BG_expT,BG_smthBloc2*1000,'b');
ylim([-max(abs([BG_Bloc1 BG_Bloc2]*1000)) max(abs([BG_Bloc1 BG_Bloc2]*1000))]);
xlabel('(ms)'); ylabel('Field Evolution (uT)'); xlim([0 max(BG_expT)]); title('Smoothed Transient Fields');

subplot(2,3,5); hold on;
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,BG_Grad*1000,clr);
plot(BG_expT,BG_smthGrad*1000,'k');
ylim([-max(abs(BG_Grad*1000)) max(abs(BG_Grad*1000))]);
xlabel('(ms)'); ylabel('Gradient Evolution (uT/m)'); xlim([0 max(BG_expT)]); title('Transient Field (Gradient)');

subplot(2,3,6); hold on;
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,BG_B01*1000,clr); 
plot(BG_expT,BG_smthB01*1000,'k'); 
ylim([-max(abs(BG_B01*1000)) max(abs(BG_B01*1000))]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(BG_expT)]); title('Transient Field (B0)');


set(gcf,'units','inches');
set(gcf,'position',[3 1 14 8]);


Status2('done','',2);
Status2('done','',3);