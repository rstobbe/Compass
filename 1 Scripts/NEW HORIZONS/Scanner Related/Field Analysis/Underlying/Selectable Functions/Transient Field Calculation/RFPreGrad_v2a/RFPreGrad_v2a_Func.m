%====================================================
%        
%====================================================

function [TF,err] = RFPreGrad_v2a_Func(TF,INPUT)

Status2('busy','Calculate Transient Fields',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
FEVOL = INPUT.FEVOL;
POSBG = INPUT.POSBG;
clear INPUT

%---------------------------------------------
% Load Input
%---------------------------------------------
TF_Fid1 = permute(squeeze(mean(FEVOL.TF_Fid1,1)),[2 1]);
TF_Fid2 = permute(squeeze(mean(FEVOL.TF_Fid2,1)),[2 1]);

%---------------------------------------------
% Determine Transient Fields
%---------------------------------------------
TF_Params = FEVOL.TF_Params;
TF_expT = TF_Params.dwell*(0:1:TF_Params.np-1) + 0.5*TF_Params.dwell;           % puts difference value at centre of interval
[TF_PH1,TF_PH2,TF_PH1steps,TF_PH2steps] = PhaseEvolution_v2b(TF_Fid1,TF_Fid2);
[TF_Bloc1,TF_Bloc2] = FieldEvolution_v2a(TF_PH1,TF_PH2,TF_expT);

%---------------------------------------------
% Calculate Gradient and B0
%---------------------------------------------
TF_tGrad = (TF_Bloc2 - TF_Bloc1)/POSBG.Sep;
TF_tB01 = TF_Bloc1 - TF_tGrad*POSBG.Loc1;         % TF_B01 and TF_B02 should be identical
TF_tB02 = TF_Bloc2 - TF_tGrad*POSBG.Loc2;

%---------------------------------------------
% Subtract BG
%---------------------------------------------
BG_smthGrad = interp1(POSBG.BG_expT,POSBG.BG_smthGrad,TF_expT);
BGmesh1 = meshgrid(BG_smthGrad,(1:TF_Params.pnum));
TF_Grad = TF_tGrad - BGmesh1;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
fh = figure('Name','Field During (first) Gradient','NumberTitle','off'); 
fh.Position = [200 150 1400 800];

subplot(2,3,1); hold on;
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,abs(TF_Fid1(1,:)),'r-');
plot(TF_expT,abs(TF_Fid2(1,:)),'b-');  
ylim([0 max(abs([TF_Fid1(1,:) TF_Fid2(1,:)]))*1.1]);
xlabel('(ms)'); ylabel('FID Magnitude (arb)'); xlim([0 max(TF_expT)]); title('FID Decay');

subplot(2,3,2); hold on;
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_PH1(1,:),'r-');     
plot(TF_expT,TF_PH2(1,:),'b-'); 
ylim([-max(abs([TF_PH1(1,:) TF_PH2(1,:)])) max(abs([TF_PH1(1,:) TF_PH2(1,:)]))]);
xlabel('(ms)'); ylabel('Phase Evolution (rads)'); xlim([0 max(TF_expT)]); title('Transient Phase');

subplot(2,3,3); hold on;
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_Bloc1(1,:)*1000,'r');
plot(TF_expT,TF_Bloc2(1,:)*1000,'b'); 
ylim([-max(abs([TF_Bloc1(1,:) TF_Bloc2(1,:)]*1000)) max(abs([TF_Bloc1(1,:) TF_Bloc2(1,:)]*1000))]);
xlabel('(ms)'); ylabel('Field Evolution (uT)'); xlim([0 max(TF_expT)]); title('Transient Fields');

subplot(2,3,4); hold on;
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_tGrad(1,:),'g');
plot(TF_expT,TF_Grad(1,:),'m');
ylim([-TF_Params.gval(1)*1.1 TF_Params.gval(1)*1.1]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); xlim([0 max(TF_expT)]); title('Transient Field (Gradient)');

subplot(2,3,5); hold on;
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_tB01*1000,'g'); 
plot(TF_expT,TF_tB02*1000,'g'); 
ylim([-10 10]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(TF_expT)]); title('Transient Field (B0)');

%---------------------------------------------
% Continue
%---------------------------------------------
button = questdlg('Continue?');
if strcmp(button,'No')
    err.flag = 4;
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
TF.gval = TF_Params.gval;
TF.Time = TF_expT;
TF.Geddy = TF_Grad;
TF.B0eddy = TF_tB01;
TF.Params = TF_Params;
TF.Data.TF_expT = TF_expT;
TF.Data.TF_Fid1 = TF_Fid1;
TF.Data.TF_Fid2 = TF_Fid2;
TF.Data.TF_PH1 = TF_PH1;
TF.Data.TF_PH2 = TF_PH2;
TF.Data.TF_PH1steps = TF_PH1steps;
TF.Data.TF_PH2steps = TF_PH2steps;
TF.Data.TF_Bloc1 = TF_Bloc1;
TF.Data.TF_Bloc2 = TF_Bloc2;
TF.Data.TF_Grad = TF_Grad;
TF.Data.TF_B01 = TF_tB01;
TF.Data.TF_B02 = TF_tB02;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
TF.ExpDisp = '';

Status2('done','',2);
Status2('done','',3);

