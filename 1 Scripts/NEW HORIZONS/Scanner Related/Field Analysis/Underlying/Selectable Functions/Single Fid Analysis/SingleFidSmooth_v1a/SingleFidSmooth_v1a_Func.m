%====================================================
% 
%====================================================

function [FIDANLZ,err] = SingleFidSmooth_v1a_Func(FIDANLZ,INPUT)

Status2('busy','Single Fid Analysis',2);
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
BG_Fid1 = mean(FEVOL.BG_Fid1,1);
BG_Fid2 = BG_Fid1;

%-------------------------------------
% Load NoGradient Data
%-------------------------------------
BG_expT = FEVOL.BG_Params.dwell*(0:1:FEVOL.BG_Params.np-1) + 0.5*FEVOL.BG_Params.dwell;           % puts difference value at centre of interval
[BG_PH1,BG_PH2,BG_PH1steps,BG_PH2steps] = PhaseEvolution_v2b(BG_Fid1,BG_Fid2);
[BG_Bloc1,BG_Bloc2] = FieldEvolution_v2a(BG_PH1,BG_PH2,BG_expT);  

%-------------------------------------
% Remove BG Oscillation (i.e. smooth)
%-------------------------------------
Status2('busy','Remove Oscillation',3);
ftBG_Bloc1 = fft(BG_Bloc1);
initftBG_Bloc1 = ftBG_Bloc1(1:FIDANLZ.smoothfraction/2*length(BG_Bloc1));
midftBG_Bloc1 = ftBG_Bloc1(FIDANLZ.smoothfraction/2*length(BG_Bloc1)+1:end-FIDANLZ.smoothfraction/2*length(BG_Bloc1));
endftBG_Bloc1 = ftBG_Bloc1(end-FIDANLZ.smoothfraction/2*length(BG_Bloc1)+1:end);
ftBG_smthBloc1 = [initftBG_Bloc1 smooth(midftBG_Bloc1,FIDANLZ.smoothfactor,'rloess').' endftBG_Bloc1];
BG_smthBloc1 = ifft(ftBG_smthBloc1);
%---------------------
figure(10000); hold on;
freq = linspace(-1/(2*FEVOL.BG_Params.dwell),1/(2*FEVOL.BG_Params.dwell)-1/(length(ftBG_Bloc1)*FEVOL.BG_Params.dwell),length(ftBG_Bloc1));
plot(freq,fftshift(abs(ftBG_Bloc1)));
plot(freq,fftshift(abs(ftBG_smthBloc1)));
xlabel('kHz');
title('Loc1 FT & Smooth')
%---------------------
if max(imag(BG_smthBloc1(:))) > 1e-4 
    test = max(imag(BG_smthBloc1(:)))
    error
end
BG_smthBloc1 = real(BG_smthBloc1);

%---------------------------------------------
% Returned
%---------------------------------------------
FIDANLZ.BG_expT = BG_expT;
FIDANLZ.BG_smthBloc1 = BG_smthBloc1;
FIDANLZ.BG_Params = FEVOL.BG_Params;
FIDANLZ.Data.BG_expT = BG_expT;
FIDANLZ.Data.BG_Fid1 = BG_Fid1;
FIDANLZ.Data.BG_PH1 = BG_PH1;
FIDANLZ.Data.BG_Bloc1 = BG_Bloc1;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
FIDANLZ.ExpDisp = '';

Status2('done','',2);
Status2('done','',3);


