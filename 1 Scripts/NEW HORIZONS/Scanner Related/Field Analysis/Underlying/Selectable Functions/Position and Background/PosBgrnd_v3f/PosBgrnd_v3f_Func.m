%====================================================
% 
%====================================================

function [POSBG,err] = PosBgrndSmooth_v3e_Func(POSBG,INPUT)

Status2('busy','Calculate Postition and Background Fields',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
FEVOL = INPUT.FEVOL;
clear INPUT

%---------------------------------------------
% Load Input
%---------------------------------------------
PL_Fid1 = mean(FEVOL.PL_Fid1,1);
PL_Fid2 = mean(FEVOL.PL_Fid2,1);
BG_Fid1 = mean(FEVOL.BG_Fid1,1);
BG_Fid2 = mean(FEVOL.BG_Fid2,1);

%---------------------------------------------
% PosLoc Data
%---------------------------------------------
PL_Params = FEVOL.PL_Params;
PL_expT = PL_Params.dwell*(0:1:PL_Params.np-1) + 0.5*PL_Params.dwell;           % puts difference value at centre of interval
[PL_PH1,PL_PH2,PL_PH1steps,PL_PH2steps] = PhaseEvolution_v2b(PL_Fid1,PL_Fid2);
[PL_Bloc1,PL_Bloc2] = FieldEvolution_v2a(PL_PH1,PL_PH2,PL_expT);
PL_ind1 = find(PL_expT>=POSBG.plstart,1,'first');
PL_ind2 = find(PL_expT>=POSBG.plstop,1,'first'); 

%---------------------------------------------
% Load NoGradient Data
%---------------------------------------------
BG_expT = FEVOL.BG_Params.dwell*(0:1:FEVOL.BG_Params.np-1) + 0.5*FEVOL.BG_Params.dwell;           % puts difference value at centre of interval
[BG_PH1,BG_PH2,BG_PH1steps,BG_PH2steps] = PhaseEvolution_v2b(BG_Fid1,BG_Fid2);
[BG_Bloc1,BG_Bloc2] = FieldEvolution_v2a(BG_PH1,BG_PH2,BG_expT);  
if strcmp(POSBG.bgstop,'end')
    bgstop = BG_expT(end);
else
    bgstop = str2double(POSBG.bgstop);
end
BG_ind1 = find(BG_expT>=POSBG.bgstart,1,'first');
BG_ind2 = find(BG_expT>=bgstop,1,'first');
if isempty(BG_ind2)
    BG_ind2 = length(BG_expT);
end

meanBGGrad = 0;
for w = 1:2
   %---------------------------------------------
    % Deternime Position
    %---------------------------------------------
    glocval = PL_Params.gval + meanBGGrad;
    Loc1 = mean(PL_Bloc1(PL_ind1:PL_ind2))/glocval;
    Loc2 = mean(PL_Bloc2(PL_ind1:PL_ind2))/glocval;
    Sep = Loc2 - Loc1;

    %---------------------------------------------
    % Determine Background Fields
    %--------------------------------------------- 
    BG_Grad = (BG_Bloc2 - BG_Bloc1)/Sep;
    BG_B01 = BG_Bloc1 - BG_Grad*Loc1;
    BG_B02 = BG_Bloc2 - BG_Grad*Loc2;        
    meanBGGrad = mean(BG_Grad(BG_ind1:BG_ind2));
    meanBGB0 = mean([BG_B01(BG_ind1:BG_ind2) BG_B02(BG_ind1:BG_ind2)]);    
end

%---------------------------------------------
% For Plotting
%---------------------------------------------
PL_Grad = (PL_Bloc2 - PL_Bloc1)/Sep;
PL_B01 = PL_Bloc1 - PL_Grad*Loc1;         
PL_B02 = PL_Bloc2 - PL_Grad*Loc2;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
fh = figure('Name','Position Locator Analysis','NumberTitle','off'); 
fh.Position = [400 150 1000 800];

subplot(2,2,1); hold on;
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,PL_PH1,'r-');     
plot(PL_expT,PL_PH2,'b-'); 
xlabel('(ms)'); ylabel('Phase Evolution (rads)'); xlim([0 POSBG.plstop+0.3]); title('Transient Phase');

subplot(2,2,2); hold on;
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,PL_Bloc1,'r');     
plot(PL_expT,PL_Bloc2,'b'); 
xlabel('(ms)'); ylabel('Field Evolution (mT)'); xlim([0 POSBG.plstop+0.3]); title('Transient Fields');

subplot(2,2,3); hold on;
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,PL_Grad,'g');     
plot([POSBG.plstart POSBG.plstart],[PL_Params.gval-0.2 PL_Params.gval+0.2],'k');
plot([POSBG.plstop POSBG.plstop],[PL_Params.gval-0.2 PL_Params.gval+0.2],'k');
ylim([PL_Params.gval-0.3 PL_Params.gval+0.3]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); xlim([0 POSBG.plstop+0.3]); title('Transient Field (Gradient)');

subplot(2,2,4); hold on;
plot([0 max(PL_expT)],[0 0],'k:'); 
plot(PL_expT,PL_B01*1000,'g'); 
plot(PL_expT,PL_B02*1000,'g'); 
ylim([-10 10]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 POSBG.plstop+0.3]); title('Transient Field (B0)');

%---------------------------------------------
% Determine Max Phase in Averaged Regions
%---------------------------------------------
PL_PH1steps = PL_PH1steps(PL_ind1:PL_ind2);
PL_PH2steps = PL_PH2steps(PL_ind1:PL_ind2);
maxPL_PH1step = max(abs(PL_PH1steps));
maxPL_PH2step = max(abs(PL_PH2steps));
if maxPL_PH1step > 2.75 || maxPL_PH2step > 2.75
    figure(100); hold on;
    plot(PL_expT(PL_ind1:PL_ind2),PL_PH1steps,'r'); 
    plot(PL_expT(PL_ind1:PL_ind2),PL_PH2steps,'b');
    err.flag = 1;
    err.msg = 'Probable error with probe displacement - increase sampling rate';
    return
end

%---------------------------------------------
% Continue
%---------------------------------------------
button = questdlg('Continue? (test for constant evaluation region)');
if strcmp(button,'No')
    err.flag = 4;
    return
end

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
fh = figure('Name','Background Field Analysis','NumberTitle','off'); 
fh.Position = [200 150 1400 800];

subplot(2,3,1); hold on;
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,abs(BG_Fid1),'r-');
plot(BG_expT,abs(BG_Fid2),'b-');  
ylim([0 max(abs([BG_Fid1 BG_Fid2]))*1.1]);
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
plot(BG_expT,BG_Grad*1000,'g');
plot([POSBG.bgstart POSBG.bgstart],[-30 30],'k');
plot([bgstop bgstop],[-30 30],'k');
ylim([-40 40]);
xlabel('(ms)'); ylabel('Gradient Evolution (uT/m)'); xlim([0 max(BG_expT)]); title('Transient Field (Gradient)');

subplot(2,3,5); hold on;
plot([0 max(BG_expT)],[0 0],'k:'); 
plot(BG_expT,BG_B01*1000,'g'); 
ylim([-10 10]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(BG_expT)]); title('Transient Field (B0)');

%---------------------------------------------
% Remove BG Oscillation (i.e. smooth)
%---------------------------------------------
Status2('busy','Remove Oscillation',3);
tBG_Grad = BG_Grad(BG_ind1:end);

figure(100);
plot(tBG_Grad);


fttBG_Grad = fft(tBG_Grad);
initfttBG_Grad = fttBG_Grad(1:ceil(POSBG.smoothfraction/2*length(tBG_Grad)));
midfttBG_Grad = fttBG_Grad(ceil(POSBG.smoothfraction/2*length(tBG_Grad))+1:end-ceil(POSBG.smoothfraction/2*length(tBG_Grad)));
endfttBG_Grad = fttBG_Grad(end-ceil(POSBG.smoothfraction/2*length(tBG_Grad))+1:end);
fttBG_smthGrad = [initfttBG_Grad smooth(midfttBG_Grad,POSBG.smoothfactor,'rloess').' endfttBG_Grad];
BG_smthGrad = ifft(fttBG_smthGrad);
if max(imag(BG_smthGrad(:))) > 1e-4
    test = max(imag(BG_smthGrad(:)))
    error
end
BG_smthGrad = [NaN*(ones(1,BG_ind1-1)) real(BG_smthGrad)];

%---------------------------------------------
% Plot
%---------------------------------------------
figure('Name','Remove Oscillation from Background Gradient Field','NumberTitle','off'); hold on;
freq = linspace(-1/(2*FEVOL.BG_Params.dwell),1/(2*FEVOL.BG_Params.dwell)-1/(length(fttBG_Grad)*FEVOL.BG_Params.dwell),length(fttBG_Grad));
plot(freq,fftshift(real(fttBG_Grad)));
plot(freq,fftshift(real(fttBG_smthGrad)));
xlabel('kHz');
title('Loc1 FT & Smooth')

figure(fh);
subplot(2,3,4); hold on;
plot(BG_expT,BG_smthGrad*1000,'k');

%---------------------------------------------
% Continue
%---------------------------------------------
button = questdlg('Continue? (test for oscillation removal)');
if strcmp(button,'No')
    err.flag = 4;
    return
end

%---------------------------------------------
% Returned
%---------------------------------------------
POSBG.Loc1 = Loc1;
POSBG.Loc2 = Loc2;
POSBG.Sep = Sep;
POSBG.meanBGGrad = meanBGGrad;
POSBG.meanBGB0 = meanBGB0;
POSBG.BG_expT = BG_expT;
POSBG.BG_smthBloc1 = BG_smthBloc1;
POSBG.BG_smthBloc2 = BG_smthBloc2; 
POSBG.PL_Params = PL_Params;
POSBG.BG_Params = FEVOL.BG_Params;
POSBG.Data.PL_expT = PL_expT;
POSBG.Data.BG_expT = BG_expT;
POSBG.Data.PL_Fid1 = PL_Fid1;
POSBG.Data.PL_Fid2 = PL_Fid2;
POSBG.Data.BG_Fid1 = BG_Fid1;
POSBG.Data.BG_Fid2 = BG_Fid2;
POSBG.Data.PL_PH1 = PL_PH1;
POSBG.Data.PL_PH2 = PL_PH2;
POSBG.Data.BG_PH1 = BG_PH1;
POSBG.Data.BG_PH2 = BG_PH2;
POSBG.Data.PL_Bloc1 = PL_Bloc1;
POSBG.Data.PL_Bloc2 = PL_Bloc2;
POSBG.Data.BG_Bloc1 = BG_Bloc1;
POSBG.Data.BG_Bloc2 = BG_Bloc2;
POSBG.Data.PL_Grad = PL_Grad;
POSBG.Data.PL_B01 = PL_B01;
POSBG.Data.PL_B02 = PL_B02;
POSBG.Data.BG_Grad = BG_Grad;
POSBG.Data.BG_smthGrad = BG_smthGrad;
POSBG.Data.BG_B01 = BG_B01;
POSBG.Data.BG_B02 = BG_B02;
POSBG.Data.BG_smthB01 = BG_smthB01;
POSBG.Data.BG_smthB02 = BG_smthB02;
POSBG.Data.maxPL_PH1step = maxPL_PH1step;
POSBG.Data.maxPL_PH2step = maxPL_PH2step;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Loc1 (cm)',Loc1*100,'Output'};
Panel(2,:) = {'Loc2 (cm)',Loc2*100,'Output'};
Panel(3,:) = {'Sep (cm)',Sep*100,'Output'};
Panel(4,:) = {'meanBGGrad (uT/m)',meanBGGrad*1000,'Output'};
Panel(5,:) = {'meanBGB0 (uT)',meanBGB0*1000,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
POSBG.PanelOutput = PanelOutput;
POSBG.ExpDisp = PanelStruct2Text(POSBG.PanelOutput);

Status2('done','',2);
Status2('done','',3);


