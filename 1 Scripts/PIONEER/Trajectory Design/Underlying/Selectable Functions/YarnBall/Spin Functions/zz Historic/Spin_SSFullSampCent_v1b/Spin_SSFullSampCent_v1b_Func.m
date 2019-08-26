%====================================================
% 
%====================================================

function [SPIN,err] = Spin_SSFullSampCent_v1b_Func(SPIN,INPUT)

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
SPIN.r = (0:0.0001:1);
SPIN.spincalcnprojarr = SPIN.spincalcnprojfunc(SPIN.r);
SPIN.spincalcndiscsarr = SPIN.spincalcndiscsfunc(SPIN.r);

%------------------------------------------
% Visuals
%------------------------------------------
Vis = 'Yes';
if strcmp(Vis,'Yes') 
    figure(2010); hold on; 
    plot(SPIN.r,PROJdgn.nproj./SPIN.spincalcnprojarr,'r-','linewidth',2); 
    xlabel('Relative Radial Value'); ylabel('Relative Spin Speed');
    rradcen = (SPIN.FSMD/2)/PROJdgn.rad;
    plot([rradcen rradcen],[0 PROJdgn.nproj./SPIN.spincalcnprojarr(1)*1.05],'k:');
    button = questdlg('Continue?');
    if strcmp(button,'No') 
        err.flag = 4;
        err.msg = 'User terminated';
    end
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

rradcen = (SPIN.FSMD/2)/PROJdgn.rad + SPIN.smoothcenshift;
spincen = SPIN.CenSamp*PROJdgn.nproj;
spingbl = SPIN.GblSamp;
reltranslen = SPIN.reltranslen;
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
proftemp = [prof(1)*ones(1,5000) prof];
profft = fftshift(fft(ifftshift(proftemp)));
filt = [zeros(7400,1);kaiser(201,SPIN.smoothbeta);zeros(7400,1)];
proftemp = fftshift(ifft(ifftshift(filt'.*profft)));
prof = proftemp(5001:length(proftemp));
prof(R > 0.75) = PROJdgn.nproj/spingbl;

spincalcnproj = interp1(R,prof,r,'cubic','extrap');
