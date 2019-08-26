%====================================================
% 
%====================================================

function [SPIN,err] = Spin_ArbSampCent_v2a_Func(SPIN,INPUT)

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
SPIN.spincalcnprojarr = SPIN.spincalcnprojfunc(SPIN.r);
SPIN.spincalcndiscsarr = SPIN.spincalcndiscsfunc(SPIN.r);

%------------------------------------------
% Visuals
%------------------------------------------
Vis = 'Yes';
if strcmp(Vis,'Yes') 
    figure(2010); hold on; 
    plot(SPIN.r,PROJdgn.nproj./SPIN.spincalcnprojarr,'k-','linewidth',2); 
    %plot(SPIN.r,1./SPIN.spincalcndiscsarr,'b-','linewidth',2); 
    xlabel('Relative Radial Value'); ylabel('Relative Spin Speed');
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
SPIN.PanelOutput = struct();
Status2('done','',2);
Status2('done','',3);


%=============================================
function spincalcnproj = Profile(r,SPIN,PROJdgn)

beta = SPIN.beta;
if beta >= 200;
    shift = 0.03;
end

R = 0:0.001:1;
rradfs = (SPIN.FSMD/2)/PROJdgn.rad + shift;
for n = 1:length(R)    
    if R(n) <= rradfs
        prof(n) = PROJdgn.nproj/SPIN.CenSamp;
    else
        prof(n) = PROJdgn.nproj/SPIN.GblSamp;
    end
end

profft = fftshift(fft(prof));
filt = [zeros(350,1);kaiser(301,beta);zeros(350,1)];
prof2 = ifft(ifftshift(filt'.*profft));

for n = 1:length(R)    
    if R(n) <= rradfs/4
        prof2(n) = PROJdgn.nproj/SPIN.CenSamp;
    elseif R(n) >= rradfs*2
        prof2(n) = PROJdgn.nproj/SPIN.GblSamp;
    end
end
spincalcnproj = interp1(R,prof2,r,'cubic','extrap');

