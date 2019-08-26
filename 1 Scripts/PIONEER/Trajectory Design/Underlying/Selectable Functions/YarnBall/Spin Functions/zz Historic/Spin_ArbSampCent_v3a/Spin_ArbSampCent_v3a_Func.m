%====================================================
% 
%====================================================

function [SPIN,err] = Spin_ArbSampCent_v3a_Func(SPIN,INPUT)

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
    xlabel('Relative Radial Value'); ylabel('Relative Spin Speed');
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
SPIN.PanelOutput = struct();
Status2('done','',2);
Status2('done','',3);


%====================================================
% Spin Function
%====================================================
function spincalcnproj = Profile(r,SPIN,PROJdgn)

rradcen = (SPIN.FSMD/2)/PROJdgn.rad + 0.01;
spincen = PROJdgn.nproj/SPIN.CenSamp;
spingbl = PROJdgn.nproj/SPIN.GblSamp;
reltranslen = SPIN.reltranslen;
slope = (spincen-spingbl)/reltranslen;

%---------------------------------------------
% Calculate Transition
%--------------------------------------------- 
trans = spincen - (0.001:0.001:reltranslen)*slope;

%---------------------------------------------
% Create Rough Shape
%--------------------------------------------- 
R = 0:0.001:1;
prof = spingbl*ones(1,1001);
lencen = ceil(rradcen/0.001)+1;
cen = spincen*ones(1,lencen);
prof(1:lencen) = cen;
prof(lencen+1:lencen+length(trans)) = trans;

%---------------------------------------------
% Smooth
%--------------------------------------------- 
beta = 15;
profft = fftshift(fft(prof));
filt = [zeros(350,1);kaiser(301,beta);zeros(350,1)];
prof2 = ifft(ifftshift(filt'.*profft));

prof2(R < rradcen/2) = spincen;
prof2(R > rradcen + reltranslen*1.5) = spingbl;

spincalcnproj = interp1(R,prof2,r,'cubic','extrap');

