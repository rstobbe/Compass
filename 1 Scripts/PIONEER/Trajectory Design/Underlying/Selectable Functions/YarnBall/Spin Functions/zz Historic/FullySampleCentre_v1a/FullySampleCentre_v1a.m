%====================================================
% Uniform
%====================================================

function [spincalcnprojifunc,spincalcndiscsifunc] = FullySampleCentre_v1a(PROJipt,USAMP)

USAMP.FSMD = str2double(PROJipt(strcmp('FullSampMatrixDiam',{PROJipt.labelstr})).entrystr);
USAMP.USfactor = str2double(PROJipt(strcmp('USfactor',{PROJipt.labelstr})).entrystr);
USAMP.OSCfactor = str2double(PROJipt(strcmp('OSCfactor',{PROJipt.labelstr})).entrystr);

spincalcnprojifunc = @(r) Profile(r,USAMP);
spincalcndiscsifunc = @(r) sqrt(Profile(r,USAMP)/2);

function spincalcnproj = Profile(r,USAMP)

R = 0:0.001:1;
rradfs = (USAMP.FSMD/2)/USAMP.rad + 0.01;
for n = 1:length(R)    
    if R(n) <= rradfs
        prof(n) = 1/USAMP.OSCfactor;
    else
        prof(n) = USAMP.nproj;
    end
end

beta = 25;
profft = fftshift(fft(prof));
filt = [zeros(350,1);kaiser(301,beta);zeros(350,1)];
prof2 = ifft(ifftshift(filt'.*profft));

for n = 1:length(R)    
    if R(n) <= rradfs/2
        prof2(n) = 1/USAMP.OSCfactor;
    elseif R(n) >= rradfs*1.5
        prof2(n) = USAMP.nproj;
    end
end

%figure(1); hold on;
%plot(R,prof2,'k','linewidth',2);

spincalcnproj = interp1(R,prof2,r,'cubic','extrap');

