%=========================================================
% 
%=========================================================

function [TST,err] = MpRageAnlzSiemens_v1a_Func(TST,INPUT)

Status2('busy','MpRage Analysis (Siemens Parameters)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
T1 = INPUT.NMR.T1;
clear INPUT;
TR = TST.TR;
TI = TST.TI;
TurboFactor = TST.TurboFactor;
EchoSpace = TST.EchoSpace;
RelEcho = TST.RelEcho/100;
Flip = TST.Flip;
BW = TST.BW;

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
TIdel = round(TI - (TurboFactor/2)*EchoSpace);
if TIdel <= 0
    err.flag = 1;
    err.msg = ['Minimum TI: ',num2str(TI-TIdel)];
    return
end
TD = round(TR - TIdel - TurboFactor*EchoSpace);
if TD < 0
    err.flag = 1;
    err.msg = ['Minimum TR: ',num2str(TR-TD)];
    return
end
SampDur = (0.5+RelEcho)*1000/BW;
SampDutyCycle = (SampDur*TurboFactor)/TR;

%---------------------------------------------
% Arrays
%---------------------------------------------
M0 = [-1 -1];
M = 1-(1-M0).*exp(-[(0:TIdel);(0:TIdel)].'./T1);
time = (0:TIdel);

for m = 1:3

    for n = 0:TurboFactor-1
        M2 = cos(pi*Flip/180)*M(end,:);
        M(end+1,:) = 1-(1-M2).*exp(-EchoSpace./T1);
        time(end+1) = time(end)+EchoSpace;
    end    
 
    AQ0mrk(m) = time(end - TurboFactor); 
    TEmrk(m) = time(end - TurboFactor/2);
    TEseg(m) = length(time) - TurboFactor/2;
    AQ1mrk(m) = time(end); 
    
    M(end+1:end+TD,:) = 1-(1-M(end,:)).*exp(-[(1:TD);(1:TD)].'./T1);
    time = [time time(end)+(1:TD)];

    TRmrk(m) = time(end);
    
    M(end+1:end+TIdel,:) = 1-(1+M(end,:)).*exp(-[(1:TIdel);(1:TIdel)].'./T1);
    time = [time time(end)+(1:TIdel)];

end

MDif = M(:,2)-M(:,1);

hFig = figure(100); hold on;
plot(time,M);
%plot(time,MDif)
plot([AQ0mrk(end) AQ0mrk(end)],[-1 1],'k:');
plot([AQ1mrk(end) AQ1mrk(end)],[-1 1],'k:');
plot([TEmrk(end) TEmrk(end)],[-1 1],'k:');
plot([0 time(end)],[0 0],'k:');
ylim([-1 1]);
xlim([time(end)-TR-2*TIdel time(end)]);

box on
hFig.Units = 'Inches';
hFig.Position = [8 6 2.9 2.2];
TST.Figure(1).Name = 'SigEvo';
TST.Figure(1).Type = 'Graph';
TST.Figure(1).hFig = hFig;
TST.Figure(1).hAx = gca;

%---------------------------------------------
% Output Values
%---------------------------------------------
MzDifValTE = MDif(TEseg(end))
SigDifValTE = abs(sin(pi*Flip/180)*MzDifValTE)
CNR = SigDifValTE*sqrt(SampDutyCycle)

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',TST.method,'Output'};
Panel(3,:) = {'TI PreDelay',TIdel,'Output'};
Panel(4,:) = {'TR PostDelay',TD,'Output'};
Panel(5,:) = {'SampDutyCycle',SampDutyCycle,'Output'};
Panel(6,:) = {'MzDifValTE',MzDifValTE,'Output'};
Panel(7,:) = {'SigDifValTE',SigDifValTE,'Output'};
Panel(8,:) = {'rCNR',CNR,'Output'};
TST.Panel = Panel;

Status2('done','',2);
Status2('done','',3);





