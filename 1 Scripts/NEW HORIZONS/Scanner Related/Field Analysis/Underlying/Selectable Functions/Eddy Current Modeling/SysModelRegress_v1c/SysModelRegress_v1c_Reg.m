%=========================================================
% 
%=========================================================

function E = SysModelRegress_v1c_Reg(V,ECM,INPUT)

%---------------------------------------------
% Get Input
%---------------------------------------------
C0 = INPUT.C0;
Clab = INPUT.Clab;
Vlab = INPUT.Vlab;
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
% Get Estimates
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

%-----------------------------------------------------
% Gradient Time Shift
%-----------------------------------------------------
Time = Time + gdel/1000;

%-----------------------------------------------------
% Resample Gmeas at Centre of Each Gradient Step
%-----------------------------------------------------
csGmeas = interp1(Time,Gmeas,csTdes,'linear','extrap');    
%csGmeas = interp1(Time,Gmeas,csTdes,'linear');  

%----------------------------------------------
% Add Transient Response
%----------------------------------------------
Status2('busy','Add Transient Response',2);
func = str2func([ECM.atrfunc,'_Func']);
INPUT.G = permute(ssGdes,[2 1]);
INPUT.gstepdur = gstepdur;
INPUT.tc = tc;
INPUT.mag = mag;
tc
mag
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
%E = permute(csGmeas,[2 1]) - csGeddyadd(1:length(csGmeas));  
E = csGmeas - csGeddyadd(1:length(csGmeas)); 
%Esum = sum(abs(E))

%---------------------------------------------
% Plot 
%---------------------------------------------
% clf(figure(10));
% figure(10); hold on;
% plot(t,-squeeze(eddy0(:,:))*100);
% plot(t,-eddy*100,'k','linewidth',2);
% title('Eddy Current from Regression');
% xlabel('(ms)'); ylabel('Gradient (%)'); 

clf(figure(11));
figure(11); hold on;
plot(L,Gvis,'k');
plot(Time,Gmeas,'r');
plot(csTdes,csGmeas,'r','linewidth',2);
plot(Teddy,-Geddy,'c-');
plot(csTeddy,csGeddyadd,'b-');
title('Regressed Transient Field (c) plus Applied Gradient (k) yeilds Projected Field (b)');
xlabel('(ms)'); ylabel('Gradient (mT/m)'); 

clf(figure(12));
figure(12); hold on;
plot(csTdes,E,'k');
plot(csTdes,smooth(E,2000),'k','linewidth',2);
title('Error Between Data (r) and Projected Gradient Field (b)');
xlabel('(ms)'); ylabel('Gradient (mT/m)'); 


