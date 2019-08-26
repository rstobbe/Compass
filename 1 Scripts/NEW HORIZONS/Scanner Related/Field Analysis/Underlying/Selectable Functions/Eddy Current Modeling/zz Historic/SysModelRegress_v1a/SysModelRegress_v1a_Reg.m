%=========================================================
% 
%=========================================================

function E = SysModelRegress_v1a_Reg(V,ECM,INPUT)

%---------------------------------------------
% Get Input
%---------------------------------------------
Time = INPUT.Time;
Gmeas = INPUT.Gmeas;
csTdes = INPUT.csTdes;
ssTdes = INPUT.ssTdes;
ssGdes = INPUT.ssGdes;
gstepdur = INPUT.gstepdur;
scale = INPUT.scale;
L = INPUT.L;
Gvis = INPUT.Gvis;
ATR = ECM.ATR;
clear INPUT

%---------------------------------------------
% Test Number of Exponentials
%---------------------------------------------
if length(V) == 3
    tc = V(1)/scale;
    mag = V(2);
    gdel = V(3);
elseif length(V) == 5
    tc = [V(1) V(3)]/scale;
    mag = [V(2) V(4)];
    gdel = V(5);    
elseif length(V) == 7
    tc = [V(1) V(3) V(5)]/scale;
    mag = [V(2) V(4) V(6)];
    gdel = V(7);  
end

%-----------------------------------------------------
% Gradient Time Shift
%-----------------------------------------------------
Time = Time + gdel/1000;

%-----------------------------------------------------
% Resample Gmeas at Centre of Each Gradient Step
%-----------------------------------------------------
csGmeas = interp1(Time,Gmeas,csTdes,'linear','extrap');    

%----------------------------------------------
% Add Transient Response
%----------------------------------------------
Status2('busy','Add Transient Response',2);
func = str2func([ECM.atrfunc,'_Func']);
INPUT.G = ssGdes;
INPUT.gstepdur = gstepdur;
INPUT.tc = tc;
INPUT.mag = mag;
[ATR,err] = func(ATR,INPUT);
if err.flag
    return
end
t = ATR.t;
eddy0 = ATR.eddy0;
eddy = ATR.eddy;
Geddy = ATR.Geddy;
Geddyadd = ATR.Geddyadd;
Teddy = ATR.Teddy;

%---------------------------------------------
% Sample Geddyadd at Centre of Step
%---------------------------------------------
csGeddyadd = Geddyadd(2:2:length(Geddyadd));
csTeddy = Teddy(2:2:length(Teddy));

%---------------------------------------------
% Find Error
%---------------------------------------------
E = permute(csGmeas,[2 1]) - csGeddyadd(1:length(csGmeas));  
%Esum = sum(abs(E))

%---------------------------------------------
% Plot 
%---------------------------------------------
clf(figure(10));
figure(10); hold on;
plot(t,-squeeze(eddy0(:,:))*100);
plot(t,-eddy*100,'k','linewidth',2);
title('Eddy Current from Regression');
xlabel('(ms)'); ylabel('Gradient (%)'); 

clf(figure(11));
figure(11); hold on;
plot(L,Gvis,'k');
plot(csTdes,csGmeas,'r');
plot(Teddy,-Geddy,'c-');
plot(csTeddy,csGeddyadd,'b-');
title('Regressed Transient Field (c) plus Applied Gradient (k) yeilds Projected Field (b)');
xlabel('(ms)'); ylabel('Gradient (mT/m)'); 

clf(figure(12));
figure(12); hold on;
plot(csTdes,E,'k');
title('Error Between Data (r) and Projected Gradient Field (b)');
xlabel('(ms)'); ylabel('Gradient (mT/m)'); 


