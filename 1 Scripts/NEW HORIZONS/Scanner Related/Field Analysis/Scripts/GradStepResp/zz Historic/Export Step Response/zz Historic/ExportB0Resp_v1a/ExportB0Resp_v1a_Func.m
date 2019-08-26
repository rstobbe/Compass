%==================================================
% 
%==================================================

function [EXPORT,err] = ExportB0Resp_v1a_Func(EXPORT,INPUT)

Status('busy','Export Step Response');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
EDDY = INPUT.EDDY;
clear INPUT

%-----------------------------------------------------
% Common Variables
%-----------------------------------------------------
B0start = EXPORT.B0start;
B0stop = EXPORT.B0stop;
slpmid = EXPORT.slpmid;

%-----------------------------------------------------
% Get Gradient Info
%-----------------------------------------------------
GRD = EXPORT.GRD;
T = GRD.T;
G = squeeze(GRD.G(:,1));
L = GRD.L;
Gvis = GRD.Gvis;
gmax = GRD.gmax;
ind = find(abs(G)==gmax,1,'last');
initdecay = T(ind+1);

%-----------------------------------------------------
% Get Transient Field Info
%-----------------------------------------------------
Time = EDDY.Time;
Geddy = EDDY.Geddy;
B0eddy = EDDY.B0eddy;
gval = EDDY.gval;
dwell = EDDY.TF.Params.dwell;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(1000); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,Geddy,'k-');     
plot(L,Gvis,'b-');
plot([initdecay initdecay],[-gmax*1.1 gmax*1.1],'k:');
plot([slpmid slpmid],[-gmax*1.1 gmax*1.1],'k:');
%ylim([-max(abs(Geddy)) max(abs(Geddy))]);
ylim([-max(abs(Geddy)) 2]);
xlim([initdecay-0.1 initdecay+0.5]); 
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)'); 
figure(1001); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,B0eddy*1000/gval,'k-');
plot(L,10*Gvis/max(Gvis),'b-');
ylim([-0.2 0.2]);
%xlim([initdecay-0.1 initdecay+0.5]); 
xlabel('(ms)'); ylabel('B0 Evolution (uT/(mT/m))'); title('Transient Field (B0)'); 

%-----------------------------------------------------
% Get B0 oscillation
%-----------------------------------------------------
ind1 = find(Time>=B0start,1,'first');
ind2 = find(Time>=B0stop,1,'first');
startT = Time(ind1);

%-----------------------------------------------------
% Interp Beginning
%-----------------------------------------------------
timeinit = (-(startT-slpmid)/2:dwell:startT-slpmid-dwell);
initguess = -1e-3*cos(2*pi*timeinit/0.73);
B0sub = [initguess B0eddy(ind1:ind2)];
figure(100); hold on;
Timesub = (-(startT-slpmid)/2:dwell:B0stop-slpmid);
plot(Timesub,B0sub*1000/gval,'k');
xlabel('(ms)'); ylabel('B0 Evolution (uT/(mT/m))'); title('Transient Field (B0)'); 

%-----------------------------------------------------
% Smooth
%-----------------------------------------------------
FTB0 = fftshift(fft(B0sub));
len = length(FTB0);
figure(101); hold on;
plot(abs(FTB0));
FTB0(len/2+1-7:len/2+1+7) = 0;
FTB0(1:len/2+1-50) = 0;
FTB0(len/2+1+50:len) = 0;
plot(abs(FTB0),'r');
B0sub2 = ifft(ifftshift(FTB0));
figure(100);
plot(Timesub,B0sub2*1000/gval,'r');

%-----------------------------------------------------
% Isolate
%-----------------------------------------------------
ind = find(Timesub>=0,1,'first');
Time = Timesub(ind:length(Timesub));
B0 = B0sub2(ind:length(Timesub))*1000/gval;
plot(Time,B0,'g','linewidth',2);

%-----------------------------------------------------
% Return
%-----------------------------------------------------
EXPORT.B0 = B0;
EXPORT.Time = Time;

