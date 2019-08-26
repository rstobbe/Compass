%====================================================
% 
%====================================================

function [SPIN,err] = Spin_Belladonna_v1a_Func(SPIN,INPUT)

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
% Proj Number Recalculate
%---------------------------------------------
SPIN.ndiscs = round(sqrt(PROJdgn.nproj/2))-0.5;
SPIN.nspokes = 2*round(sqrt(PROJdgn.nproj*2)/2);
SPIN.nproj = SPIN.ndiscs*SPIN.nspokes;
SPIN.AziSampUsed = 1;
SPIN.PolSampUsed = 1;

%---------------------------------------------
% Recalculate p
%---------------------------------------------
SPIN.p = sqrt(SPIN.nproj/(2*pi^2*PROJdgn.rad^2));                     % abstract ref...

%---------------------------------------------
% Spin Functions
%---------------------------------------------
SPIN.spincalcndiscsfunc = @(r) SPIN.ndiscs;
SPIN.spincalcnspokesfunc = @(r) SPIN.nspokes;

%------------------------------------------
% Name
%------------------------------------------
SPIN.type = 'Uniform';
SPIN.number = num2str(100,'%3.0f');
SPIN.name = ['U',SPIN.number];
SPIN.GblSamp = 1;

%--------------------------------------------- 
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Method',SPIN.method,'Output'};
Panel(2,:) = {'Ndiscs',SPIN.ndiscs,'Output'};
Panel(3,:) = {'Nspokes',SPIN.nspokes,'Output'};

SPIN.Panel = Panel;
Status2('done','',2);
Status2('done','',3);

