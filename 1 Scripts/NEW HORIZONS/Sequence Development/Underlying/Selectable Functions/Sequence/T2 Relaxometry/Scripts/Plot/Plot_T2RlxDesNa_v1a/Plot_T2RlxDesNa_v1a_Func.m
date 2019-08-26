%==================================================
% 
%==================================================

function [OUTPUT,err] = Plot_T2RlxDesNa_v1a_Func(PLOT,INPUT)

Status('busy','Plot');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
RLXDES = INPUT.RLXDES;
clear INPUT

T2f = RLXDES.T2f;
T2s = RLXDES.T2s;
T2fout = RLXDES.T2fout;
T2sout = RLXDES.T2sout;
SMNR = RLXDES.SMNR;
N = RLXDES.N;

%-----------------------------------------------------
% Calc
%-----------------------------------------------------
rT2fstd = std(T2fout,0,3)/T2f;
rT2sstd = std(T2sout,0,3)/T2s;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(10); hold on;
for n = 1:length(N)
    plot(SMNR,rT2fstd(n,:),'k-');
    plot(SMNR,rT2sstd(n,:),'b-');    
end
ylabel('Relative Standard Deviation of Measured Tc');
xlabel('SMNR');

%-----------------------------------------------------
% Prediction Interval (19/20)
%-----------------------------------------------------
rel = PLOT.PI/200;

%-----------------------------------------------------
% interp
%-----------------------------------------------------
for n = 1:length(N)
    reqSMNRT2f(n) = interp1(rT2fstd(n,:),SMNR,rel);
    reqSMNRT2s(n) = interp1(rT2sstd(n,:),SMNR,rel);    
end
figure(11); hold on;
plot(N,reqSMNRT2f,'k');
plot(N,reqSMNRT2s,'b');
ylabel('Required SMNR');
xlabel('N Time Points in Relaxometry');
legend('T2f','T2s');

relstudylenT2f = N.*(reqSMNRT2f.^2); 
relstudylenT2s = N.*(reqSMNRT2s.^2); 
figure(12); hold on;
plot(N,relstudylenT2f,'k');
plot(N,relstudylenT2s,'b');
plot(N,(relstudylenT2f+relstudylenT2s)/2,'r');
ylabel('Relative Study Duration');
xlabel('N Time Points in Relaxometry');
legend('T2f','T2s');


%==================================================
% 
%==================================================
function OutStyle
outstyle = 1;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[3 3 3 3]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 1.6 1.3]);
    set(gca,'fontsize',10,'fontweight','bold');
end