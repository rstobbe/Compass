%====================================================
% 
%====================================================

function [SPIN,err] = Spin_PlusGaussian_v2a_Func(SPIN,INPUT)

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

Profile = @(r) PROJdgn.nproj./((SPIN.CenSamp-1).*Gaussian(r) + 1);
SPIN.spincalcnprojfunc = @(r) Profile(r);
SPIN.spincalcndiscsfunc = @(r) sqrt(Profile(r)/2);
SPIN.GblSamp = PROJdgn.nproj./SPIN.spincalcnprojfunc(1);

%---------------------------------------------
% Test Array
%--------------------------------------------- 
SPIN.r = (0:0.001:1);
SPIN.spincalcnprojarr = SPIN.spincalcnprojfunc(SPIN.r);
SPIN.spincalcndiscsarr = SPIN.spincalcndiscsfunc(SPIN.r);

%------------------------------------------
% Visuals
%------------------------------------------
if strcmp(SPIN.Vis,'Yes') 
    figure(2010); hold on; 
    plot(SPIN.r,PROJdgn.nproj./SPIN.spincalcnprojarr,'k-','linewidth',2); 
    %plot(SPIN.r,1./SPIN.spincalcndiscsarr,'b-','linewidth',2); 
    xlabel('Relative Radial Value'); ylabel('Relative Spin Speed');
    button = questdlg('Continue?');
    if strcmp(button,'No') 
        err.flag = 4;
        err.msg = '';
        return
    end
end