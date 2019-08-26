%=========================================================
% 
%=========================================================

function [SNR,err] = MultiImSNRCalc_v1a_Func(INPUT,SNR)

Status('busy','Calculate SNR');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Ims = INPUT.Ims;
clear INPUT;

%---------------------------------------------
% Calculate
%---------------------------------------------
sz = length(Ims(:,1,1,1));

j = 1;
for n = sz/2-8:sz/2+1
    for m = sz/2-8:sz/2+1
        for p = sz/2-8:sz/2+1
            Pts = abs(squeeze(Ims(n,m,p,:)));
            if mean(Pts) > SNR.minval
                snr(j) = mean(Pts)/std(Pts);
                j = j+1;
            end
        end
    end
end

%msnr = dfittool(real(snr))
%sdvsnr = std(snr)
msnr = mean(snr)

%---------------------------------------------
% Return
%---------------------------------------------
SNR.snr = msnr;

Status('done','');
Status2('done','',2);
Status2('done','',3);
