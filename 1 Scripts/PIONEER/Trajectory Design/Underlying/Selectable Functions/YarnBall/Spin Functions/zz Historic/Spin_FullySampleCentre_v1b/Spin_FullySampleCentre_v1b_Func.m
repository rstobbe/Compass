%====================================================
% 
%====================================================

function [SPIN,err] = Spin_FullySampleCentre_v1b_Func(SPIN)

Status2('busy','Define Spinning Functions',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;

%---------------------------------------------
% Calculate Spin Functions
%---------------------------------------------
SPIN.spincalcnprojfunc = @(r) Profile(r,SPIN,PROJdgn);
SPIN.spincalcndiscsfunc = @(r) sqrt(Profile(r,SPIN,PROJdgn)/2);

%---------------------------------------------
% Test Array
%--------------------------------------------- 
SPIN.r = (0:0.001:1);
SPIN.spincalcnprojarr = SPIN.spincalcnprojfunc(r);
SPIN.spincalcndiscsarr = SPIN.spincalcndiscsfunc(r);

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
SPIN.PanelOutput = struct();
Status2('done','',2);
Status2('done','',3);


%=============================================
function spincalcnproj = Profile(r,SPIN,PROJdgn)

R = 0:0.001:1;
rradfs = (SPIN.FSMD/2)/PROJdgn.rad + 0.01;
for n = 1:length(R)    
    if R(n) <= rradfs
        prof(n) = 1/SPIN.CenSamp;
    else
        prof(n) = PROJdgn.nproj;
    end
end

beta = 25;
profft = fftshift(fft(prof));
filt = [zeros(350,1);kaiser(301,beta);zeros(350,1)];
prof2 = ifft(ifftshift(filt'.*profft));

for n = 1:length(R)    
    if R(n) <= rradfs/2
        prof2(n) = 1/SPIN.CenSamp;
    elseif R(n) >= rradfs*1.5
        prof2(n) = PROJdgn.nproj;
    end
end
spincalcnproj = interp1(R,prof2,r,'cubic','extrap');

