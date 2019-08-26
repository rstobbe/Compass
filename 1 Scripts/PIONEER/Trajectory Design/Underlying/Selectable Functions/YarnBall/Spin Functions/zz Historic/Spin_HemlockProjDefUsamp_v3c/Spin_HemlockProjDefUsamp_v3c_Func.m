%====================================================
% 
%====================================================

function [SPIN,err] = Spin_HemlockProjDefUsamp_v3c_Func(SPIN,INPUT)

Status2('busy','Define Spinning Functions',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;

%---------------------------------------------
% Proj Number Recalculate
%---------------------------------------------
SPIN.nproj = SPIN.ndiscs*SPIN.nspokes;
dproj = SPIN.nproj/SPIN.UnderSamp;
SPIN.AziSampUsed = SPIN.ndiscs/sqrt(dproj/2);
SPIN.PolSampUsed = SPIN.nspokes/sqrt(dproj*2);
SPIN.UnderSampUsed = SPIN.AziSampUsed*SPIN.PolSampUsed;

%---------------------------------------------
% Recalculate p
%---------------------------------------------
SPIN.p = sqrt(dproj/(2*pi^2*PROJdgn.rad^2));                     % abstract ref...

%---------------------------------------------
% Calculate Spin Functions
%---------------------------------------------
SPIN.spincalcnprojfunc = @(r) dproj;
SPIN.spincalcndiscsfunc = @(r) sqrt(dproj/2);
SPIN.spincalcnspokesfunc = @(r) 2*sqrt(dproj/2);
SPIN.spiralaccom = (PROJdgn.rad+SPIN.SpiralOverShoot)/PROJdgn.rad;

%---------------------------------------------
% Test Array
%--------------------------------------------- 
SPIN.r = (0:0.001:1);
SPIN.spincalcnprojarr = SPIN.spincalcnprojfunc(SPIN.r);
SPIN.spincalcndiscsarr = SPIN.spincalcndiscsfunc(SPIN.r);

%------------------------------------------
% Visuals (useless visual - straight line)
%------------------------------------------
%if strcmp(SPIN.Vis,'Yes') 
    %figure(2010); hold on; 
    %plot(PROJdgn.nproj*SPIN.r,PROJdgn.nproj./SPIN.spincalcnprojarr,'k-','linewidth',2); 
    %plot(SPIN.r,1./SPIN.spincalcndiscsarr,'b-','linewidth',2); 
    %xlabel('Relative Radial Value'); ylabel('Relative Spin Speed');
%end

%------------------------------------------
% Name
%------------------------------------------
SPIN.type = 'Uniform';
SPIN.number = num2str(100*SPIN.UnderSampUsed,'%3.0f');
SPIN.name = ['U',SPIN.number];
SPIN.GblSamp = SPIN.UnderSampUsed;

%--------------------------------------------- 
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Method',SPIN.method,'Output'};
Panel(2,:) = {'PolUsamp',SPIN.PolSampUsed,'Output'};
Panel(3,:) = {'AziUsamp',SPIN.AziSampUsed,'Output'};

SPIN.Panel = Panel;
Status2('done','',2);
Status2('done','',3);

