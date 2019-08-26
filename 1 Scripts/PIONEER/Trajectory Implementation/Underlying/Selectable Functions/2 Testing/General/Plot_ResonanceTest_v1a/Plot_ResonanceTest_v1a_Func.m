%==================================================
% 
%==================================================

function [PLOT,err] = Plot_ResonanceTest_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Resonance Test',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
IMP = INPUT.IMP;
SYS = IMP.SYS;
Gseg = SYS.GradSampBase/1000;
%GQNT = IMP.GQNT;
clear INPUT

G = IMP.G;
sz = size(G);

%----------------------------------------------------
% Test
%----------------------------------------------------  
if (PLOT.TR/Gseg) < sz(2)
    err.flag = 1;
    err.msg = 'TR too small';
    return
end

%----------------------------------------------------
% Build Sequence
%----------------------------------------------------    
zfG = zeros(100000,3);
Reps = 25;
for n = 1:Reps
    zfG((n-1)*(PLOT.TR/Gseg)+(1:sz(2)),:) = G(n,:,:);
end

zfRefSin = zeros(100000,1);
RefSin = 30*sin(100*2*pi*(0:Gseg:PLOT.TR*Reps)/1000);
zfRefSin(1:length(RefSin)) = RefSin;

figure(293485); hold on;
plot(zfG(:,1));
plot(zfRefSin);
xlim([0 length(RefSin)]);


%----------------------------------------------------
% Calculate Acoustic Frequency Response
%----------------------------------------------------    
zfGX = zfG(:,1);
zfGY = zfG(:,2);
zfGZ = zfG(:,3);     
ftGX = abs(fftshift(fft(zfGX)));
ftGY = abs(fftshift(fft(zfGY)));
ftGZ = abs(fftshift(fft(zfGZ)));    

ftRefSin = abs(fftshift(fft(zfRefSin)));

hFig = figure(1137134); hold on;
fstep = 1/(100000*Gseg);
freq = (-1/(2*Gseg):fstep:(1/(2*Gseg))-fstep);
freq = freq*1000;
plot(freq,ftRefSin/max(ftRefSin(:)),'k');
plot(freq,ftGX/max(ftRefSin(:)),'b-'); plot(freq,ftGY/max(ftRefSin(:)),'g-'); plot(freq,ftGZ/max(ftRefSin(:)),'r-');    
title('Acoustic Resonance (Relative to 30 mT/m Sinusoid at 100 Hz)');
xlabel('(Hz)','fontsize',10,'fontweight','bold');
ylabel('Relative Magnitude','fontsize',10,'fontweight','bold');
xlim([0 2000]);
plot([SYS.AcousticFreqsCen(1)-SYS.AcousticFreqsHBW(1) SYS.AcousticFreqsCen(1)-SYS.AcousticFreqsHBW(1)],[0 1],'k:');
plot([SYS.AcousticFreqsCen(1)+SYS.AcousticFreqsHBW(1) SYS.AcousticFreqsCen(1)+SYS.AcousticFreqsHBW(1)],[0 1],'k:');
plot([SYS.AcousticFreqsCen(2)-SYS.AcousticFreqsHBW(2) SYS.AcousticFreqsCen(2)-SYS.AcousticFreqsHBW(2)],[0 1],'k:');
plot([SYS.AcousticFreqsCen(2)+SYS.AcousticFreqsHBW(2) SYS.AcousticFreqsCen(2)+SYS.AcousticFreqsHBW(2)],[0 1],'k:');
hAx = gca;

%---------------------------------------------
% Return
%---------------------------------------------
PLOT.Name = 'AcousticResonance';
fig = 1;
PLOT.Figure(fig).Name = 'AcousticResonance';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = hFig;
PLOT.Figure(fig).hAx = hAx;

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',PLOT.method,'Output'};
PLOT.Panel = Panel;
