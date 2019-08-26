%====================================================
% 
%====================================================

function [SPIN,err] = Spin_SportWeight_v1c_Func(SPIN,INPUT)

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
undersamptot = SPIN.PolSamp*SPIN.AziSamp;
dproj = PROJdgn.nproj/undersamptot;

ndiscs0 = round(sqrt(dproj/2)*SPIN.AziSamp);
if strcmp(SPIN.ForceOddSpokes,'Yes')
    nspokes0 = floor(sqrt(dproj*2)*SPIN.PolSamp/2)*2+1;
else
    nspokes0 = round(sqrt(dproj*2)*SPIN.PolSamp);
end

%---------------------------------------------
% Check if previously 'fixed'
%---------------------------------------------
previousfix = 0;
if ndiscs0*nspokes0 ~= PROJdgn.nproj
    for ndiscs = ndiscs0-1:1:ndiscs0+1
        for nspokes = nspokes0-1:1:nspokes0+1
            if ndiscs*nspokes == PROJdgn.nproj
                SPIN.ndiscs = ndiscs;
                SPIN.nspokes = nspokes;
                previousfix = 1;
                break
            end
        end
    end
end
if previousfix == 0
    SPIN.ndiscs = ndiscs0;
    SPIN.nspokes = nspokes0;
end

%---------------------------------------------
% Recalc
%---------------------------------------------
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
SPIN.number = num2str(100*undersamptot,'%3.0f');
SPIN.name = ['U',SPIN.number];
SPIN.GblSamp = undersamptot;

%--------------------------------------------- 
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Method',SPIN.method,'Output'};
Panel(2,:) = {'AziUsamp',SPIN.AziSampUsed,'Output'};
Panel(3,:) = {'PolUsamp',SPIN.PolSampUsed,'Output'};
Panel(4,:) = {'Ndiscs',SPIN.ndiscs,'Output'};
Panel(5,:) = {'Nspokes',SPIN.nspokes,'Output'};

SPIN.Panel = Panel;
Status2('done','',2);
Status2('done','',3);

