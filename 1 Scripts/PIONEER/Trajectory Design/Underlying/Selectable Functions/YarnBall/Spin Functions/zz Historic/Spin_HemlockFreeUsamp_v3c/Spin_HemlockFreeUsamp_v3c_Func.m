%====================================================
% 
%====================================================

function [SPIN,err] = Spin_HemlockFreeUsamp_v3c_Func(SPIN,INPUT)

Status2('busy','Define Spinning Functions',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
clear INPUT;

%---------------------------------------------
% Default
%---------------------------------------------
SPIN.ForceOddSpokes = 'Yes';

%---------------------------------------------
% Proj Number Recalculate
%---------------------------------------------
undersamptot = SPIN.PolSamp*SPIN.AziSamp;
dproj = PROJdgn.nproj/undersamptot;

SPIN.ndiscs = round(sqrt(dproj/2)*SPIN.AziSamp);
if strcmp(SPIN.ForceOddSpokes,'Yes')
    SPIN.nspokes = floor(sqrt(dproj*2)*SPIN.PolSamp/2)*2+1;
else
    SPIN.nspokes = round(sqrt(dproj*2)*SPIN.PolSamp);
end
SPIN.nproj = SPIN.ndiscs*SPIN.nspokes;
dproj = SPIN.nproj/undersamptot;
SPIN.AziSampUsed = SPIN.ndiscs/sqrt(dproj/2);
SPIN.PolSampUsed = SPIN.nspokes/sqrt(dproj*2);

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

%---------------------------------------------
% Drop
%    - this should go in DesMeth
%---------------------------------------------
%SPIN.spiralaccom = (PROJdgn.rad+SPIN.SpiralOverShoot)/PROJdgn.rad;         

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
SPIN.number = num2str(100*SPIN.PolSamp,'%3.0f');
SPIN.name = ['U',SPIN.number];
SPIN.GblSamp = SPIN.PolSamp;

%--------------------------------------------- 
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Method',SPIN.method,'Output'};
Panel(2,:) = {'PolUsamp',SPIN.PolSampUsed,'Output'};
Panel(3,:) = {'AziUsamp',SPIN.AziSampUsed,'Output'};
Panel(4,:) = {'Ndiscs',SPIN.ndiscs,'Output'};
Panel(5,:) = {'Nspokes',SPIN.nspokes,'Output'};

SPIN.Panel = Panel;
Status2('done','',2);
Status2('done','',3);

