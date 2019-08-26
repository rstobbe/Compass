%==================================
% 
%==================================

function [RGRS,err] = TrajModelFitting_v1b_Func(RGRS,INPUT)

Status('busy','Regress Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EDDY = INPUT.EDDY;
ECM = INPUT.ECM;
IMP = INPUT.IMP;
clear INPUT;

%-----------------------------------------------------
% Get Gradient Info
%-----------------------------------------------------
trajno = 1;
dir = 3;
Tdes = IMP.qTscnr;
Gdes = IMP.G(trajno,:,dir);

%-----------------------------------------------------
% Zero Fill Trajectory
%-----------------------------------------------------
Tadd = (Tdes(2):Tdes(2):2) + Tdes(length(Tdes));
Tdes = [Tdes Tadd];
Gdes = [Gdes zeros(1,length(Tadd))];

%-----------------------------------------------------
% Traj Vis
%-----------------------------------------------------
Gvis = 0; L = 0;
for n = 1:length(Tdes)-1
    L = [L [Tdes(n) Tdes(n+1)]];
    Gvis = [Gvis [Gdes(n) Gdes(n)]];
end


%-----------------------------------------------------
% Get Values
%-----------------------------------------------------
time0 = EDDY.Time;
eddy0 = EDDY.Geddy;
tcest = RGRS.tcest;
magest = RGRS.magest; 
gstepdur = Tdes(2);

%-----------------------------------------------------
% TDes to middle
%-----------------------------------------------------
Tdes = Tdes(1:length(Tdes)-1);
%Tdisp = Tdes + gstepdur/2;

%-----------------------------------------------------
% Gradient Time Shift
%-----------------------------------------------------
time0 = time0 + RGRS.gstartshift/1000;

%-----------------------------------------------------
% Plot Gradient Design
%-----------------------------------------------------
doplot = 1;
if doplot == 1
    figure(5000); hold on;
    plot(L,Gvis,'b-');
    %plot(Tdisp,Gdes,'r-');    % put in middle of step for visual
    plot(time0,eddy0,'k-');
    xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)');
end

%-----------------------------------------------------
% Resample Eddy
%-----------------------------------------------------
eddy = interp1(time0,eddy0,Tdes,'linear','extrap');

%-----------------------------------------------------
% Initial Plot
%-----------------------------------------------------
doplot = 1;
if doplot == 1
    figure(5001); hold on;
    plot(Tdes,Gdes,'r*');    % put in middle of step for visual
    plot(Tdes,eddy,'k*');
    xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)');
end

%-----------------------------------------------------
% Save
%-----------------------------------------------------
RGRS.Time = Tdes;
RGRS.Gmeas = eddy;
RGRS.Gdes = permute(Gdes,[2 1]);

%-----------------------------------------------------
% Regression Setup
%-----------------------------------------------------
regfunc = str2func([RGRS.modelfunc,'_Reg']);
options = optimset( 'Algorithm','levenberg-marquardt',...           % levenberg-marquardt (trust-region-reflective)
                    'Diagnostics','on',...                    
                    'DiffMinChange',1e-2,...                        % 
                    'Display','iter',...
                    'FinDiffType','forward',...                     % forward (central)    
                    'TolFun',1e-5);                                 % measure relative change in least-squares
lb = [];                                                            % not used for 'levenberg-marquardt'               
ub = [];

%-----------------------------------------------------
% Scale
%-----------------------------------------------------
scale = 10000;

%-----------------------------------------------------
% Regression Function Input
%-----------------------------------------------------
INPUT.scale = scale;
INPUT.Time = RGRS.Time;
INPUT.Gmeas = RGRS.Gmeas;
INPUT.Gdes = RGRS.Gdes;
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
    RGRS.tc = V(1)/scale;
    RGRS.mag = V(2);
    Panel(1,:) = {'Tc (ms)',RGRS.tc,'Output'};
    Panel(2,:) = {'Mag (%)',RGRS.mag,'Output'};    
elseif length(tcest) == 2
    RGRS.tc1 = V(1)/scale;
    RGRS.mag1 = V(2);
    RGRS.tc2 = V(3)/scale;
    RGRS.mag2 = V(4);
    Panel(1,:) = {'Tc1 (ms)',RGRS.tc1,'Output'};
    Panel(2,:) = {'Mag1 (%)',RGRS.mag1,'Output'};    
    Panel(3,:) = {'Tc2 (ms)',RGRS.tc2,'Output'};
    Panel(4,:) = {'Mag2 (%)',RGRS.mag2,'Output'};    
elseif length(tcest) == 3
    RGRS.tc1 = V(1)/scale;
    RGRS.mag1 = V(2);
    RGRS.tc2 = V(3)/scale;
    RGRS.mag2 = V(4);
    RGRS.tc3 = V(5)/scale;
    RGRS.mag3 = V(6);
    Panel(1,:) = {'Tc1 (ms)',RGRS.tc1,'Output'};
    Panel(2,:) = {'Mag1 (%)',RGRS.mag1,'Output'};    
    Panel(3,:) = {'Tc2 (ms)',RGRS.tc2,'Output'};
    Panel(4,:) = {'Mag2 (%)',RGRS.mag2,'Output'};   
    Panel(5,:) = {'Tc3 (ms)',RGRS.tc3,'Output'};
    Panel(6,:) = {'Mag3 (%)',RGRS.mag3,'Output'};   
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
RGRS.PanelOutput = PanelOutput;



