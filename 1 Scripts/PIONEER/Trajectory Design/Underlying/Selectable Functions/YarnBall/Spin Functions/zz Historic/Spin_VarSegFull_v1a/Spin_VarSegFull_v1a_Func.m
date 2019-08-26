%====================================================
% 
%====================================================

function [SPIN,err] = Spin_UniSeg_v1a_Func(SPIN,INPUT)

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




dproj = PROJdgn.nproj/undersamptot;

SPIN.ndiscs = round(sqrt(dproj/2)*SPIN.AziSamp);
if strcmp(SPIN.ForceSpokes,'Odd')
    SPIN.nspokes = floor(sqrt(dproj*2)*SPIN.PolSamp/2)*2+1;
elseif strcmp(SPIN.ForceSpokes,'Mult')
    if SPIN.PolSamp/SPIN.AziSamp < 0.75
        SPIN.nspokes = SPIN.ndiscs;
    else
        SPIN.nspokes = 2*SPIN.ndiscs;
    end
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

