%==================================
% 
%==================================

function [ECM,err] = ExpModelTest_v1b_Func(ECM,INPUT)

Status2('busy','Test Eddy Currents',2);
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
ATR = ECM.ATR;
clear INPUT;

%-----------------------------------------------------
% SubSamp Tdes For Eddy Current Add
%-----------------------------------------------------
%ssTdes = (0:gstepdur/2:Tdes(length(Tdes))+gstepdur/2);
for n = 1:length(Gdes)
    ssGdes(n*2-1:n*2) = Gdes(n);
end
ssGdes = permute(ssGdes,[2 1]);

%-----------------------------------------------------
% Resample Gmeas at Centre of Each Gradient Step
%-----------------------------------------------------
csTdes = Tdes+gstepdur/2;
csGmeas = interp1(Time,Gmeas,Tdes+gstepdur/2,'linear','extrap'); 

%-----------------------------------------------------
% Common
%-----------------------------------------------------
tcest = ECM.tcest;
magest = ECM.magest;
   
%-----------------------------------------------------
% Add Transient Responase
%-----------------------------------------------------
Status2('busy','Add Transient Response',2);
func = str2func([ECM.atrfunc,'_Func']);
INPUT.G = ssGdes;
INPUT.gstepdur = gstepdur/2;
INPUT.tc = tcest;
INPUT.mag = magest;
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
Esum = sum(abs(E))

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

ECM.PanelOutput = cell(0);

Status2('done','',2);
Status2('done','',3);
