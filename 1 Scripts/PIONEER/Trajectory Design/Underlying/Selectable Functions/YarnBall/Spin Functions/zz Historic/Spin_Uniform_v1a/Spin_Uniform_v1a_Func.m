%====================================================
% 
%====================================================

function [SPIN,err] = Spin_Uniform_v1a_Func(SPIN,INPUT)

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
spincalcnproj = round(PROJdgn.nproj/SPIN.GblSamp);
spinclacndiscs = sqrt(spincalcnproj/2);
SPIN.spincalcnprojfunc = @(r) spincalcnproj;
SPIN.spincalcndiscsfunc = @(r) spinclacndiscs;

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
    plot(PROJdgn.nproj*SPIN.r,PROJdgn.nproj./SPIN.spincalcnprojarr,'k-','linewidth',2); 
    %plot(SPIN.r,1./SPIN.spincalcndiscsarr,'b-','linewidth',2); 
    xlabel('Relative Radial Value'); ylabel('Relative Spin Speed');
end