%==================================
% 
%==================================

function [ECM,err] = SysModelRegress_v1c_Func(ECM,INPUT)

Status2('busy','Regress Eddy Currents',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Time = INPUT.Time;
Gmeas = INPUT.Gmeas;
Tdes = INPUT.Tdes;
Gdes = INPUT.Gdes;
gstepdur = INPUT.gstepdur;
L = INPUT.L;
Gvis = INPUT.Gvis;
clear INPUT;

%-----------------------------------------------------
% SubSamp Tdes For Eddy Current Add
%-----------------------------------------------------
ssTdes = (0:gstepdur/2:Tdes(length(Tdes))+gstepdur/2);
for n = 1:length(Gdes)
    ssGdes(n*2-1:n*2) = Gdes(n);
end
ssGdes = permute(ssGdes,[2 1]);

%-----------------------------------------------------
% Centre of Each Gradient Step
%-----------------------------------------------------
csTdes = Tdes+gstepdur/2;    

%---------------------------------------------
% Sub Traj  
%---------------------------------------------
if not(strcmp(ECM.subrgrslen,'full'))
    subrgrslen = str2double(ECM.subrgrslen);
    ind = find(csTdes > subrgrslen,1,'first');           
    csTdes = csTdes(1:ind);
end

%-----------------------------------------------------
% Common
%-----------------------------------------------------
tcest = ECM.tcest;
tcconst = ECM.tcconst;
magest = ECM.magest;
magconst = ECM.magconst;
gdelest = ECM.gdelest;
gdelconst = ECM.gdelconst;

%-----------------------------------------------------
% Regression Setup
%-----------------------------------------------------
regfunc = str2func([ECM.method,'_Reg']);
options = optimset( 'Algorithm','levenberg-marquardt',...           % levenberg-marquardt (trust-region-reflective)
                    'Diagnostics','on',...                    
                    'Display','iter',...
                    'FinDiffType','forward',...                     % forward (central)    
                    'TolFun',1e-5);                                 % measure relative change in least-squares
lb = [];                                                            % not used for 'levenberg-marquardt'               
ub = [];

%-----------------------------------------------------
% Scale
%-----------------------------------------------------
scale = 1000;

%-----------------------------------------------------
% Initial Estimates
%-----------------------------------------------------
n = 1;
V0 = [];
Vlab = cell(0);
if length(gdelest) == 1
    V0(n) = gdelest;
    Vlab{n} = 'gdelest';
    n = n+1;
end
for m = 1:length(tcest)
    V0(n) = tcest(m)*scale;
    Vlab{n} = 'tcest';
    n = n+1;
end
for m = 1:length(magest)
    V0(n) = magest(m);
    Vlab{n} = 'magest';
    n = n+1;
end

%-----------------------------------------------------
% Constants
%-----------------------------------------------------
n = 1;
C0 = [];
Clab = cell(0);
if length(gdelconst) == 1
    C0(n) = gdelconst;
    Clab{n} = 'gdelconst';
    n = n+1;
end
for m = 1:length(tcconst)
    C0(n) = tcconst(m)*scale;
    Clab{n} = 'tcconst';
    n = n+1;
end
for m = 1:length(magconst)
    C0(n) = magconst(m);
    Clab{n} = 'magconst';
    n = n+1;
end

%-----------------------------------------------------
% Regression Function Input
%-----------------------------------------------------
INPUT.C0 = C0;
INPUT.Clab = Clab;
INPUT.Vlab = Vlab;
INPUT.Time = Time;
INPUT.Gmeas = Gmeas;
INPUT.scale = scale;
INPUT.csTdes = csTdes;
INPUT.ssTdes = ssTdes;
INPUT.ssGdes = ssGdes;
INPUT.gstepdur = gstepdur/2;
INPUT.L = L;
INPUT.Gvis = Gvis;
func = @(V)regfunc(V,ECM,INPUT);

%-----------------------------------------------------
% Regression
%-----------------------------------------------------
[V,resnorm,residual,exitflag,output,~,jacobian] = lsqnonlin(func,V0,lb,ub,options);

%---------------------------------------------
% Get Output
%---------------------------------------------
nt = 1;
nm = 1;
for n = 1:length(Vlab)
    switch Vlab{n}
        case 'tcest'
            tc(nt) = V(n)/scale;
            nt = nt+1;
        case 'magest'
            mag(nm) = V(n);
            nm = nm+1;
        case 'gdelest'
            gdel = V(n);
    end
end

%---------------------------------------------
% Get Constants
%---------------------------------------------
for n = 1:length(Clab)
    switch Clab{n}
        case 'tcconst'
            tc(nt) = C0(n)/scale;
            nt = nt+1;
        case 'magconst'
            mag(nm) = C0(n);
            nm = nm+1;
        case 'gdelconst'
            gdel = C0(n);
    end
end

%---------------------------------------------
% Output
%---------------------------------------------
if length(tc) == 1
    ECM.tc = tc(1);
    ECM.mag = mag(1);
    ECM.gdel = gdel;
    Panel(1,:) = {'Tc (ms)',ECM.tc,'Output'};
    Panel(2,:) = {'Mag (%)',ECM.mag,'Output'};
    Panel(3,:) = {'Gdel (us)',ECM.gdel,'Output'};  
elseif length(tc) == 2
    ECM.tc(1) = tc(1);
    ECM.mag(1) = mag(1);
    ECM.tc(2) = tc(2);
    ECM.mag(2) = mag(2);
    ECM.gdel = gdel;
    Panel(1,:) = {'Tc1 (ms)',ECM.tc(1),'Output'};
    Panel(2,:) = {'Mag1 (%)',ECM.mag(1),'Output'};    
    Panel(3,:) = {'Tc2 (ms)',ECM.tc(2),'Output'};
    Panel(4,:) = {'Mag2 (%)',ECM.mag(2),'Output'};
    Panel(5,:) = {'Gdel (us)',ECM.gdel,'Output'}; 
elseif length(tc) == 3
    ECM.tc(1) = tc(1);
    ECM.mag(1) = mag(1);
    ECM.tc(2) = tc(2);
    ECM.mag(2) = mag(2);
    ECM.tc(3) = tc(3);
    ECM.mag(3) = mag(3);
    Panel(1,:) = {'Tc1 (ms)',ECM.tc(1),'Output'};
    Panel(2,:) = {'Mag1 (%)',ECM.mag(1),'Output'};    
    Panel(3,:) = {'Tc2 (ms)',ECM.tc(2),'Output'};
    Panel(4,:) = {'Mag2 (%)',ECM.mag(2),'Output'};   
    Panel(5,:) = {'Tc3 (ms)',ECM.tc(3),'Output'};
    Panel(6,:) = {'Mag3 (%)',ECM.mag(3),'Output'};
    Panel(7,:) = {'Gdel (us)',ECM.gdel,'Output'}; 
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ECM.PanelOutput = PanelOutput;


