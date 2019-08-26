%=========================================================
% 
%=========================================================

function [TST,err] = MpRageCnrOpt_v1c_Func(TST,INPUT)

Status2('busy','MpRage Optization for Cnr',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
T1 = INPUT.NMR.T1;
clear INPUT;
maxTR = TST.maxtr;
minTR = TST.mintr;
Slices = TST.slices;
nonacqtime = TST.nonacqtime;

%---------------------------------------------
% Arrays
%---------------------------------------------
TR = (minTR:maxTR);
%Flip = (9:0.01:35);
Flip = (9:0.01:25);

%---------------------------------------------
% Test
%---------------------------------------------
if length(T1) ~= 2
    err.flag = 1;
    err.msg = 'Nmrfunc should have 2 T1 values';
    return
end

%---------------------------------------------
% Sequence Parameters
%---------------------------------------------
TD = TST.TrDel;        % ms

%---------------------------------------------
% Arrays
%---------------------------------------------
TIdel = [0 20 100 200]+TST.TiDelMin;
for r = 1:length(TR)
    for k = 1:length(TIdel)
        for p = 1:length(Flip)
            M0 = [-1 -1];
            M = 1-(1-M0).*exp(-[(0:TIdel(k));(0:TIdel(k))].'./T1);
            time = (0:TIdel(k));
            for m = 1:3
                for n = 0:Slices-1
                    M2 = cos(pi*Flip(p)/180)*M(end,:);
                    M(end+1,:) = 1-(1-M2).*exp(-TR(r)./T1);
                    time(end+1) = time(end)+TR(r);
                end    
                AQ0mrk(m) = time(end - Slices); 
                TImrk(m) = time(end - Slices/2);
                TIseg(m) = length(time) - Slices/2;
                %TImrk = time(TIseg(m))
                AQ1mrk(m) = time(end);   
                M(end+1:end+TD,:) = 1-(1-M(end,:)).*exp(-[(1:TD);(1:TD)].'./T1);
                time = [time time(end)+(1:TD)];
                TRmrk(m) = time(end);  
                M(end+1:end+TIdel(k),:) = 1-(1+M(end,:)).*exp(-[(1:TIdel(k));(1:TIdel(k))].'./T1);
                time = [time time(end)+(1:TIdel(k))];
            end
            MDif = M(:,2)-M(:,1);
            MzDifValTI(p) = MDif(TIseg(end));
            SigDifValTI(p) = abs(sin(pi*Flip(p)/180)*MzDifValTI(p));
        end
        MaxSigDifValTI0(k) = max(SigDifValTI);
        ind = SigDifValTI == MaxSigDifValTI0(k);
        FlipAtMax0(k) = Flip(ind);
        MzAtMax0(k) = MzDifValTI(ind);
        TI0(k) = TImrk(1);
    end
    TRout0 = TIdel + TD + Slices*TR(r);
    TIout0 = TIdel + Slices*TR(r)/2;
    SampDutyCycle0 = Slices*(TR(r)-nonacqtime)./TRout0;
    CNR0 = MaxSigDifValTI0.*sqrt(SampDutyCycle0);
    CNR(r) = max(CNR0);
    ind = CNR0 == CNR(r); 
    OptSigDifValTi(r) = MaxSigDifValTI0(ind);
    FlipAtMax(r) = FlipAtMax0(ind);
    MzAtMax(r) = MzAtMax0(ind);
    TiDelUsed(r) = TIdel(ind);
    TIout(r) = TIout0(ind);  
    TRout(r) = TRout0(ind);  
end
    
% figure(12341234); hold on;
% %plot(
% plot(time,M(:,1));
% plot(time,M(:,2));
% plot([TImrk(end) TImrk(end)],[-0.5 0.5]);

%----------------------------------------------------
% SigDiff
%----------------------------------------------------
hFig = figure(99); hold on;
plot(TR,OptSigDifValTi);
xlim([minTR maxTR]);
% ylim([0 0.04]);
%ylim([0.015 0.025]);
xlabel('TR')
ylabel('SigDif');
box on
hFig.Units = 'Inches';
%hFig.Position = [8 6 2.9 2.2];
hFig.Position = [8 6 3.8 3.0];
TST.Figure(1).Name = 'SigDiff';
TST.Figure(1).Type = 'Graph';
TST.Figure(1).hFig = hFig;
TST.Figure(1).hAx = gca;

%----------------------------------------------------
% TI
%----------------------------------------------------
hFig = figure(100); hold on;
plot(TR,TIout);
xlim([minTR maxTR]);
% ylim([]);
xlabel('TR')
ylabel('TI');
box on
hFig.Units = 'Inches';
%hFig.Position = [8 6 2.9 2.2];
hFig.Position = [8 6 3.8 3.0];
TST.Figure(2).Name = 'TI';
TST.Figure(2).Type = 'Graph';
TST.Figure(2).hFig = hFig;
TST.Figure(2).hAx = gca;

%----------------------------------------------------
% TR
%----------------------------------------------------
hFig = figure(101); hold on;
plot(TR,TRout);
xlim([minTR maxTR]);
% ylim([]);
xlabel('TR')
ylabel('TRfull');
box on
hFig.Units = 'Inches';
%hFig.Position = [8 6 2.9 2.2];
hFig.Position = [8 6 3.8 3.0];
TST.Figure(2).Name = 'TRout';
TST.Figure(2).Type = 'Graph';
TST.Figure(2).hFig = hFig;
TST.Figure(2).hAx = gca;

%----------------------------------------------------
% Flip
%----------------------------------------------------
hFig = figure(102); hold on;
plot(TR,FlipAtMax);
xlim([minTR maxTR]);
% ylim([]);
xlabel('TR')
ylabel('Flip');
box on
hFig.Units = 'Inches';
%hFig.Position = [8 6 2.9 2.2];
hFig.Position = [8 6 3.8 3.0];
TST.Figure(3).Name = 'Flip';
TST.Figure(3).Type = 'Graph';
TST.Figure(3).hFig = hFig;
TST.Figure(3).hAx = gca;

%----------------------------------------------------
% CNR
%----------------------------------------------------
hFig = figure(103); hold on;
CNR0 = 0.00905;
plot(TR,CNR/CNR0);
xlim([minTR maxTR]);
ylim([1 2.7]);
xlabel('TR')
ylabel('CNR');
box on
hFig.Units = 'Inches';
%hFig.Position = [8 6 2.9 2.2];
hFig.Position = [8 6 3.8 3.0];
TST.Figure(4).Name = 'CNR';
TST.Figure(4).Type = 'Graph';
TST.Figure(4).hFig = hFig;
TST.Figure(4).hAx = gca;

%----------------------------------------------------
% Mz
%----------------------------------------------------
hFig = figure(104); hold on;
plot(TR,MzAtMax);
xlim([minTR maxTR]);
% ylim([]);
xlabel('TR')
ylabel('Mz');
box on
hFig.Units = 'Inches';
%hFig.Position = [8 6 2.9 2.2];
hFig.Position = [8 6 3.8 3.0];
TST.Figure(5).Name = 'Mz';
TST.Figure(5).Type = 'Graph';
TST.Figure(5).hFig = hFig;
TST.Figure(5).hAx = gca;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',TST.method,'Output'};
TST.Panel = Panel;

Status2('done','',2);
Status2('done','',3);




