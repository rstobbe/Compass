%==================================
% 
%==================================

function [COMP,err] = TrajImpComp_v2a_Func(COMP,INPUT)

Status('busy','Regress Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EDDY = INPUT.EDDY;
GRD = INPUT.GRD;
clear INPUT;

%-----------------------------------------------------
% Get Gradient Info
%-----------------------------------------------------
trajno = COMP.trajnum;
dir = COMP.trajortho;
if not(isfield(IMP,'Grecon'));
    Gdes = IMP.G(trajno,:,dir);
    Tdes = IMP.qTscnr;    
else
    Gdes = IMP.Grecon(trajno,:,dir);
    Tdes = IMP.qTrecon;  
end
Kmat = IMP.Kmat(trajno,:,dir);
samp = IMP.samp;

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
Time = EDDY.Time;
Gmeas = EDDY.Geddy;

%-----------------------------------------------------
% Polarity
%-----------------------------------------------------
if strcmp(COMP.gpol,'Neg')
    Gmeas = -Gmeas;
end

%-----------------------------------------------------
% Plot Gradient Comparison
%-----------------------------------------------------
doplot = 1;
if doplot == 1
    figure(4000); hold on;
    plot([0 max(L)],[0 0],'k:');     
    plot(L,Gvis,'k-');
    plot(Time-COMP.graddel/1000,Gmeas,'r-');
    xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('Transient Field (Gradient)');
    xlim([0 Time(length(Time))]);
end

%-----------------------------------------------------
% Plot Gradient Comparison
%-----------------------------------------------------
iGdes = interp1(Tdes(1:end-1),Gdes,Time-COMP.graddel/1000);
GDiff = Gmeas - iGdes;
doplot = 1;
if doplot == 1
    figure(4001); hold on;
    plot([0 max(L)],[0 0],'k:');     
    plot(Time-COMP.graddel/1000,GDiff,'r-');
    GDiff(isnan(GDiff)) = 0;
    plot(Time-COMP.graddel/1000,smooth(GDiff,2000),'b-');
    xlabel('(ms)'); ylabel('Gradient (mT/m)'); title('Transient Field Error (Gradient)');
    xlim([0 Time(length(Time))]);
end

%-----------------------------------------------------
% Calculate k-Space
%-----------------------------------------------------
kTime = Time+Time(1);       % k-values associated with end of gradient seqment
tseg = Time(2) - Time(1);
kMeas = zeros(size(Gmeas));
kMeas(1) = Gmeas(1)*42.577*tseg;
if isnan(kMeas(1))
    kMeas(1) = 0;
end
for n = 2:length(Gmeas)
    kSeg = Gmeas(n)*42.577*tseg;
    if isnan(kSeg(1))
        kSeg(1) = 0;
    end
    kMeas(n) = kMeas(n-1)+kSeg;
end

%-----------------------------------------------------
% Plot k-Space Comparison
%-----------------------------------------------------
doplot = 1;
if doplot == 1
    figure(5001); hold on;
    plot([0 max(samp)],[0 0],'k:');     
    plot(samp,Kmat,'k-*');
    plot(kTime-COMP.graddel/1000,kMeas,'r-');
    xlabel('(ms)'); ylabel('k-Space (1/m)'); title('k-Space Sampling');
    xlim([0 Time(length(Time))]);
end

%-----------------------------------------------------
% Plot k-Space Comparison
%-----------------------------------------------------
iKmat = interp1(samp,Kmat,kTime-COMP.graddel/1000);
kDiff = kMeas - iKmat;
doplot = 1;
if doplot == 1
    figure(5002); hold on;
    plot(kTime-COMP.graddel/1000,kDiff,'r-');
    xlabel('(ms)'); ylabel('k-Space (1/m)'); title('k-Space Sampling');
    xlim([0 Time(length(Time))]);
end



Status2('done','',2);
Status2('done','',3);
