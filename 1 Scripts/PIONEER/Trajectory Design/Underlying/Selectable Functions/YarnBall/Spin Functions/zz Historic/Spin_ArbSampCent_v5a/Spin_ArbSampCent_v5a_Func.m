%====================================================
% 
%====================================================

function [SPIN,err] = Spin_ArbSampCent_v5a_Func(SPIN,INPUT)

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
    figure(2011); hold on; 
    plot(SPIN.r,PROJdgn.nproj./SPIN.spincalcnprojarr,'k-','linewidth',2); 
    xlabel('Relative Radial Value'); ylabel('Relative Spin Speed');
    ylim([PROJdgn.nproj*0.99999 PROJdgn.nproj*1.00001]); 
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
spincen = SPIN.CenSamp;
spingbl = SPIN.GblSamp;
reltranslen = SPIN.reltranslen;
transbeta = SPIN.transbeta;
slope = (spincen-spingbl)/reltranslen;

%---------------------------------------------
% Calculate Transition
%--------------------------------------------- 
trans = spincen - (0.0001:0.0001:reltranslen)*slope;

%---------------------------------------------
% Create Rough Shape
%--------------------------------------------- 
R = 0:0.0001:1;
prof = spingbl*ones(1,10001);
lencen = ceil(rradcen/0.0001)+1;
cen = spincen*ones(1,lencen);
prof(1:lencen) = cen;
prof(lencen+1:lencen+length(trans)) = trans;

%---------------------------------------------
% Invert
%--------------------------------------------- 
prof = PROJdgn.nproj*(1./(prof)); 

%---------------------------------------------
% Smooth
%--------------------------------------------- 
profft = fftshift(fft(prof));
filt = [zeros(4900,1);kaiser(201,transbeta);zeros(4900,1)];
%filt = [zeros(4850,1);kaiser(301,transbeta);zeros(4850,1)];
prof = ifft(ifftshift(filt'.*profft));
prof(R < rradcen/2) = PROJdgn.nproj/spincen;
prof(R > rradcen + reltranslen*1.5) = PROJdgn.nproj/spingbl;



spincalcnproj = interp1(R,prof,r,'cubic','extrap');

