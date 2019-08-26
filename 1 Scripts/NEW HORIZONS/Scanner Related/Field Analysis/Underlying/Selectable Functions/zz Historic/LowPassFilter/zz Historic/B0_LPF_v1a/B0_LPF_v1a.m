%==================================
% 
%==================================

function [filt,SCRPTipt] = B0_LPF_v1a(Eddy,Params,SCRPTipt)

FTVis = SCRPTipt(strcmp('B0_FT Vis',{SCRPTipt.labelstr})).entrystr;
if iscell(FTVis)
    FTVis = SCRPTipt(strcmp('B0_FT Vis',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('B0_FT Vis',{SCRPTipt.labelstr})).entryvalue};
end
cutoff = str2double(SCRPTipt(strcmp('B0_cutoff (Hz)',{SCRPTipt.labelstr})).entrystr)/1000;

F1 = fftshift(fft(Eddy(1,1:length(Eddy))));
f = (-1/(2*Params.dwell):1/(length(F1)*Params.dwell):1/(2*Params.dwell)-1/(length(F1)*Params.dwell));
if strcmp(FTVis,'On')
    figure(11); hold on;
    plot(f,abs(F1));
end
f1 = find(f <= -cutoff,1,'last');
f2 = find(f <= cutoff,1,'last');
F1(1:f1-1) = 0;
F1(f2+1:length(F1)) = 0;
hamshape = hamming(f2-f1)';
ham = [zeros(1,f1),hamshape,zeros(1,length(F1)-f2)];
F1filt = F1.*ham;
if strcmp(FTVis,'On')
    plot(f,abs(F1),'r');
    plot(f,abs(F1filt),'k');
end
filt = ifft(ifftshift(F1filt));

if abs(imag(filt)) > 1e-4
    maximag = max(abs(imag(filt)))
    error('should be real');
end
filt = real(filt);