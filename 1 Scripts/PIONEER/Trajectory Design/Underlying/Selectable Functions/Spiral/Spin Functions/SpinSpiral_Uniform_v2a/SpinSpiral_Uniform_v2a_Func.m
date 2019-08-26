%====================================================
% 
%====================================================

function [SPIN,err] = SpinSpiral_Uniform_v2a_Func(SPIN,INPUT)

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
spincalcnproj = PROJdgn.nproj/SPIN.GblSamp;
SPIN.spincalcnprojfunc = @(r) spincalcnproj;

%---------------------------------------------
% Test Array
%--------------------------------------------- 
SPIN.r = (0:0.001:1);
SPIN.spincalcnprojarr = SPIN.spincalcnprojfunc(SPIN.r);

%------------------------------------------
% Visuals
%------------------------------------------
if strcmp(SPIN.Vis,'Yes') 
    figure(2010); hold on; 
    plot(PROJdgn.nproj*SPIN.r,PROJdgn.nproj./SPIN.spincalcnprojarr,'k-','linewidth',2); 
    xlabel('Relative Radial Value'); ylabel('Relative Spin Speed');
end

