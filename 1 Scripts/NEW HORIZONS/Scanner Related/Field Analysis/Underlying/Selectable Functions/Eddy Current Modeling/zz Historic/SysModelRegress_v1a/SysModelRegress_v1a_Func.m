%==================================
% 
%==================================

function [ECM,err] = SysModelRegress_v1a_Func(ECM,INPUT)

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

%-----------------------------------------------------
% Common
%-----------------------------------------------------
tcest = ECM.tcest;
magest = ECM.magest;
gdelest = ECM.gdelest;

%-----------------------------------------------------
% Regression Setup
%-----------------------------------------------------
regfunc = str2func([ECM.method,'_Reg']);
options = optimset( 'Algorithm','levenberg-marquardt',...           % levenberg-marquardt (trust-region-reflective)
                    'Diagnostics','on',...                    
                    'DiffMinChange',1e-2,...                        % 
                    'Display','iter',...
                    'FinDiffType','forward',...                     % forward (central)    
                    'TolFun',1e-3);                                 % measure relative change in least-squares
lb = [];                                                            % not used for 'levenberg-marquardt'               
ub = [];

%-----------------------------------------------------
% Scale
%-----------------------------------------------------
scale = 1000;

%-----------------------------------------------------
% Regression Function Input
%-----------------------------------------------------
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
% Initial Estimates
%-----------------------------------------------------
if length(tcest) == 1
    V0(1) = tcest*scale;
    V0(2) = magest;
    V0(3) = gdelest;
elseif length(tcest) == 2
    V0(1) = tcest(1)*scale;
    V0(2) = magest(1);
    V0(3) = tcest(2)*scale;
    V0(4) = magest(2);
    V0(5) = gdelest;
elseif length(tcest) == 3
    V0(1) = tcest(1)*scale;
    V0(2) = magest(1);
    V0(3) = tcest(2)*scale;
    V0(4) = magest(2);
    V0(5) = tcest(3)*scale;
    V0(6) = magest(3);
    V0(7) = gdelest;    
end
    
%-----------------------------------------------------
% Regression
%-----------------------------------------------------
[V,resnorm,residual,exitflag,output,~,jacobian] = lsqnonlin(func,V0,lb,ub,options);
if length(tcest) == 1
    ECM.tc = V(1)/scale;
    ECM.mag = V(2);
    ECM.gdel = V(3);
    Panel(1,:) = {'Tc (ms)',ECM.tc,'Output'};
    Panel(2,:) = {'Mag (%)',ECM.mag,'Output'};
    Panel(3,:) = {'Gdel (us)',ECM.gdel,'Output'};  
elseif length(tcest) == 2
    ECM.tc(1) = V(1)/scale;
    ECM.mag(1) = V(2);
    ECM.tc(2) = V(3)/scale;
    ECM.mag(2) = V(4);
    ECM.gdel = V(5);
    Panel(1,:) = {'Tc1 (ms)',ECM.tc(1),'Output'};
    Panel(2,:) = {'Mag1 (%)',ECM.mag(1),'Output'};    
    Panel(3,:) = {'Tc2 (ms)',ECM.tc(2),'Output'};
    Panel(4,:) = {'Mag2 (%)',ECM.mag(2),'Output'};
    Panel(5,:) = {'Gdel (us)',ECM.gdel,'Output'}; 
elseif length(tcest) == 3
    ECM.tc(1) = V(1)/scale;
    ECM.mag(1) = V(2);
    ECM.tc(2) = V(3)/scale;
    ECM.mag(2) = V(4);
    ECM.tc(3) = V(5)/scale;
    ECM.mag(3) = V(6);
    ECM.gdel = V(7);
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


