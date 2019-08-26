%====================================================
% 
%====================================================

function [SPIN,err] = Spin_Chunky_v1a_Func(SPIN,INPUT)

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
% Find Constraint
%---------------------------------------------
if 2*SPIN.ndiscs < SPIN.nspokes
    SPIN.p = SPIN.ndiscs/(pi*PROJdgn.rad);
else
    SPIN.p = SPIN.nspokes/(2*pi*PROJdgn.rad);
end

%---------------------------------------------
% Calculate Spin Functions
%---------------------------------------------
SPIN.spincalcndiscsfunc = @(r) SPIN.ndiscs/SPIN.AziSampSpin;
SPIN.spincalcnspokesfunc = @(r) SPIN.nspokes/SPIN.PolSampSpin;
SPIN.nproj = SPIN.ndiscs*SPIN.nspokes;

%------------------------------------------
% Name
%------------------------------------------
SPIN.AziSampUsed = SPIN.AziSampSpin;
SPIN.PolSampUsed = SPIN.PolSampSpin;
undersamptot = SPIN.AziSampSpin*SPIN.PolSampSpin;

SPIN.type = 'Uniform';
SPIN.number = num2str(100*undersamptot,'%3.0f');
SPIN.name = ['U',SPIN.number];
SPIN.GblSamp = undersamptot;

%--------------------------------------------- 
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Method',SPIN.method,'Output'};
Panel(2,:) = {'AziSampSpin',SPIN.AziSampSpin,'Output'};
Panel(3,:) = {'PolSampSpin',SPIN.PolSampSpin,'Output'};
Panel(4,:) = {'Ndiscs',SPIN.ndiscs,'Output'};
Panel(5,:) = {'Nspokes',SPIN.nspokes,'Output'};

SPIN.Panel = Panel;
Status2('done','',2);
Status2('done','',3);

