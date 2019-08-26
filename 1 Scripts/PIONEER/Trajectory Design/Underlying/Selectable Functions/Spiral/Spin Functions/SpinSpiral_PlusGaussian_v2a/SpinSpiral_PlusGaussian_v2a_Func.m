%====================================================
% 
%====================================================

function [SPIN,err] = SpinSpiral_PlusGaussian_v2a_Func(SPIN,INPUT)

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
Gaussian = @(r) besseli(0,SPIN.beta * sqrt(1 - r.^2)); 
Gaussian = @(r) Gaussian(r)/Gaussian(0);

Profile = @(r) PROJdgn.nproj./((SPIN.CenSamp-SPIN.GblSamp).*Gaussian(r) + SPIN.GblSamp);
SPIN.spincalcnprojfunc = @(r) Profile(r);

%---------------------------------------------
% Test Array
%--------------------------------------------- 
SPIN.r = (0:0.001:1);
SPIN.spincalcnprojarr = SPIN.spincalcnprojfunc(SPIN.r);

%------------------------------------------
% Visuals
%------------------------------------------
SPIN.Vis = 'Yes';
if strcmp(SPIN.Vis,'Yes') 
    figure(2010); hold on; 
    plot(PROJdgn.nproj*SPIN.r,PROJdgn.nproj./SPIN.spincalcnprojarr,'k-','linewidth',2); 
    xlabel('Relative Radial Value'); ylabel('Relative Spin Speed');
end

