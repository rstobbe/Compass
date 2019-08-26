%====================================================
%        
%====================================================

function [TF,err] = RFPreGradSmooth_v2a_Func(TF,INPUT)

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
TF_Fid1 = mean(FEVOL.TF_Fid1,1);
TF_Fid2 = mean(FEVOL.TF_Fid2,1);

%---------------------------------------------
% Determine Transient Fields
%---------------------------------------------
TF_expT = FEVOL.TF_Params.dwell*(0:1:FEVOL.TF_Params.np-1) + 0.5*FEVOL.TF_Params.dwell;           % puts difference value at centre of interval
[TF_PH1,TF_PH2,TF_PH1steps,TF_PH2steps] = PhaseEvolution_v2b(TF_Fid1,TF_Fid2);
[TF_Bloc1,TF_Bloc2] = FieldEvolution_v2a(TF_PH1,TF_PH2,TF_expT);

%---------------------------------------------
% Test
%---------------------------------------------
figure(3000); 
subplot(2,2,1); hold on;
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,abs(TF_Fid1),'r-');
plot(TF_expT,abs(TF_Fid2),'b-');  
ylim([-max(abs([TF_Fid1 TF_Fid2])) max(abs([TF_Fid1 TF_Fid2]))]);
xlabel('(ms)'); ylabel('FID Magnitude (arb)'); xlim([0 max(TF_expT)]); title('FID Decay');

subplot(2,2,2); hold on;
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_PH1,'r-');     
plot(TF_expT,TF_PH2,'b-'); 
ylim([-max(abs([TF_PH1 TF_PH2])) max(abs([TF_PH1 TF_PH2]))]);
xlabel('(ms)'); ylabel('Phase Evolution (rads)'); xlim([0 max(TF_expT)]); title('Transient Phase');

subplot(2,2,3); hold on;
plot([0 max(TF_expT)],[0 0],'k:'); 
plot(TF_expT,TF_Bloc1*1000,'r');
plot(TF_expT,TF_Bloc2*1000,'b'); 
ylim([-max(abs([TF_Bloc1 TF_Bloc2]*1000)) max(abs([TF_Bloc1 TF_Bloc2]*1000))]);
xlabel('(ms)'); ylabel('Field Evolution (uT)'); xlim([0 max(TF_expT)]); title('Transient Fields');

button = questdlg('Continue? (If spikes abort)');
if strcmp(button,'No')
    err.flag = 4;
    return
end

%---------------------------------------------
% Remove Oscillation (i.e. smooth)
%---------------------------------------------
Status2('busy','Remove Oscillation',3);
ftTF_Bloc1 = fft(TF_Bloc1);
initftTF_Bloc1 = ftTF_Bloc1(1:TF.smoothfraction/2*length(TF_Bloc1));
midftTF_Bloc1 = ftTF_Bloc1(TF.smoothfraction/2*length(TF_Bloc1)+1:end-TF.smoothfraction/2*length(TF_Bloc1));
endftTF_Bloc1 = ftTF_Bloc1(end-TF.smoothfraction/2*length(TF_Bloc1)+1:end);
ftTF_smthBloc1 = [initftTF_Bloc1 smooth(midftTF_Bloc1,TF.smoothfactor,'rloess').' endftTF_Bloc1];
TF_smthBloc1 = ifft(ftTF_smthBloc1);
figure(20000); 
subplot(2,1,1); hold on;
freq = linspace(-1/(2*FEVOL.TF_Params.dwell),1/(2*FEVOL.TF_Params.dwell)-1/(length(ftTF_Bloc1)*FEVOL.TF_Params.dwell),length(ftTF_Bloc1));
plot(freq,fftshift(abs(ftTF_Bloc1)));
plot(freq,fftshift(abs(ftTF_smthBloc1)));
%ylim([0 2]);
xlabel('kHz');
title('Loc1 FT & Smooth');

ftTF_Bloc2 = fft(TF_Bloc2);
initftTF_Bloc2 = ftTF_Bloc2(1:TF.smoothfraction/2*length(TF_Bloc2));
midftTF_Bloc2 = ftTF_Bloc2(TF.smoothfraction/2*length(TF_Bloc2)+1:end-TF.smoothfraction/2*length(TF_Bloc2));
endftTF_Bloc2 = ftTF_Bloc2(end-TF.smoothfraction/2*length(TF_Bloc2)+1:end);
ftTF_smthBloc2 = [initftTF_Bloc2 smooth(midftTF_Bloc2,TF.smoothfactor,'rloess').' endftTF_Bloc2];
TF_smthBloc2 = ifft(ftTF_smthBloc2);
figure(20000); 
subplot(2,1,2); hold on;
freq = linspace(-1/(2*FEVOL.TF_Params.dwell),1/(2*FEVOL.TF_Params.dwell)-1/(length(ftTF_Bloc2)*FEVOL.TF_Params.dwell),length(ftTF_Bloc2));
plot(freq,fftshift(abs(ftTF_Bloc2)));
plot(freq,fftshift(abs(ftTF_smthBloc2)));
%ylim([0 2]);
xlabel('kHz');
title('Loc2 FT & Smooth')

% test1 = max(real(TF_smthBloc1(:)))/max(imag(TF_smthBloc1(:)))
% test2 = max(real(TF_smthBloc2(:)))/max(imag(TF_smthBloc2(:)))
% if max(imag(TF_smthBloc1(:))) > 1e-3 || max(imag(TF_smthBloc2(:))) > 1e-3
%     test = max(imag(TF_smthBloc1(:)))
%     test2 = max(imag(TF_smthBloc2(:)))
%     error
% end

TF_smthBloc1 = real(TF_smthBloc1);
TF_smthBloc2 = real(TF_smthBloc2);

%---------------------------------------------
% Subtract BG
%---------------------------------------------
BG_smthBloc1 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc1,TF_expT);
BG_smthBloc2 = interp1(POSBG.BG_expT,POSBG.BG_smthBloc2,TF_expT);
BGmesh1 = meshgrid(BG_smthBloc1,(1:FEVOL.TF_Params.pnum));
BGmesh2 = meshgrid(BG_smthBloc2,(1:FEVOL.TF_Params.pnum));
corTF_Bloc1 = TF_smthBloc1 - BGmesh1;
corTF_Bloc2 = TF_smthBloc2 - BGmesh2;

%---------------------------------------------
% Calculate Gradient and B0
%---------------------------------------------
TF_Grad = (corTF_Bloc2 - corTF_Bloc1)/POSBG.Sep;
TF_B01 = corTF_Bloc1 - TF_Grad*POSBG.Loc1;         % TF_B01 and TF_B02 should be identical
TF_B02 = corTF_Bloc2 - TF_Grad*POSBG.Loc2;

%---------------------------------------------
% Return
%---------------------------------------------
TF.gval = FEVOL.TF_Params.gval;
TF.Time = TF_expT;
TF.Geddy = TF_Grad;
TF.B0eddy = TF_B01;
TF.Params = FEVOL.TF_Params;
TF.Data.TF_expT = TF_expT;
TF.Data.TF_Fid1 = TF_Fid1;
TF.Data.TF_Fid2 = TF_Fid2;
TF.Data.TF_PH1 = TF_PH1;
TF.Data.TF_PH2 = TF_PH2;
TF.Data.TF_PH1steps = TF_PH1steps;
TF.Data.TF_PH2steps = TF_PH2steps;
TF.Data.TF_Bloc1 = TF_Bloc1;
TF.Data.TF_Bloc2 = TF_Bloc2;
TF.Data.TF_smthBloc1 = TF_smthBloc1;
TF.Data.TF_smthBloc2 = TF_smthBloc2;
TF.Data.corTF_Bloc1 = corTF_Bloc1;
TF.Data.corTF_Bloc2 = corTF_Bloc2;
TF.Data.TF_Grad = TF_Grad;
TF.Data.TF_B01 = TF_B01;
TF.Data.TF_B02 = TF_B02;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
TF.ExpDisp = '';

Status2('done','',2);
Status2('done','',3);

