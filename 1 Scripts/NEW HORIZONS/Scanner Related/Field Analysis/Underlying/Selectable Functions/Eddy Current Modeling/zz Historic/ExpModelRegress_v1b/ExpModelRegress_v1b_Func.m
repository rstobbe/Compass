%==================================
% 
%==================================

function [ECM,err] = ExpModelRegress_v1b_Func(ECM,INPUT)

Status('busy','Regress Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Gmeas = INPUT.Gmeas;
Time = INPUT.Time;
Gdes = INPUT.Gdes;
gstepdur = INPUT.gstepdur;
clear INPUT;

%-----------------------------------------------------
% Common
%-----------------------------------------------------
tcest = ECM.tcest;
magest = ECM.magest;
   
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
INPUT.scale = scale;
INPUT.Time = Time;
INPUT.Gmeas = Gmeas;
INPUT.Gdes = Gdes;
INPUT.gstepdur = gstepdur;
func = @(V)regfunc(V,ECM,INPUT);

%-----------------------------------------------------
% Initial Estimates
%-----------------------------------------------------
if length(tcest) == 1
    V0(1) = tcest*scale;
    V0(2) = magest;
elseif length(tcest) == 2
    V0(1) = tcest(1)*scale;
    V0(2) = magest(1);
    V0(3) = tcest(2)*scale;
    V0(4) = magest(2);
elseif length(tcest) == 3
    V0(1) = tcest(1)*scale;
    V0(2) = magest(1);
    V0(3) = tcest(2)*scale;
    V0(4) = magest(2);
    V0(5) = tcest(3)*scale;
    V0(6) = magest(3);    
end
    
%-----------------------------------------------------
% Regression
%-----------------------------------------------------
[V,resnorm,residual,exitflag,output,~,jacobian] = lsqnonlin(func,V0,lb,ub,options);
if length(tcest) == 1
    ECM.tc = V(1)/scale;
    ECM.mag = V(2);
    Panel(1,:) = {'Tc (ms)',ECM.tc,'Output'};
    Panel(2,:) = {'Mag (%)',ECM.mag,'Output'};    
elseif length(tcest) == 2
    ECM.tc(1) = V(1)/scale;
    ECM.mag(1) = V(2);
    ECM.tc(2) = V(3)/scale;
    ECM.mag(2) = V(4);
    Panel(1,:) = {'Tc1 (ms)',ECM.tc(1),'Output'};
    Panel(2,:) = {'Mag1 (%)',ECM.mag(1),'Output'};    
    Panel(3,:) = {'Tc2 (ms)',ECM.tc(2),'Output'};
    Panel(4,:) = {'Mag2 (%)',ECM.mag(2),'Output'};    
elseif length(tcest) == 3
    ECM.tc(1) = V(1)/scale;
    ECM.mag(1) = V(2);
    ECM.tc(2) = V(3)/scale;
    ECM.mag(2) = V(4);
    ECM.tc(3) = V(5)/scale;
    ECM.mag(3) = V(6);
    Panel(1,:) = {'Tc1 (ms)',ECM.tc(1),'Output'};
    Panel(2,:) = {'Mag1 (%)',ECM.mag(1),'Output'};    
    Panel(3,:) = {'Tc2 (ms)',ECM.tc(2),'Output'};
    Panel(4,:) = {'Mag2 (%)',ECM.mag(2),'Output'};   
    Panel(5,:) = {'Tc3 (ms)',ECM.tc(3),'Output'};
    Panel(6,:) = {'Mag3 (%)',ECM.mag(3),'Output'};   
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ECM.PanelOutput = PanelOutput;


