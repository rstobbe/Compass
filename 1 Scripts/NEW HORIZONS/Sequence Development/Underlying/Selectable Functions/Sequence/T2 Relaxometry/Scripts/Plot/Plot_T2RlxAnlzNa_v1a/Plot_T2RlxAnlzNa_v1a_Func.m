%==================================================
% 
%==================================================

function [OUTPUT,err] = Plot_T2RlxAnlzNa_v1a_Func(PLOT,INPUT)

Status('busy','Plot');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
RLXANLZ = INPUT.RLXANLZ;
clear INPUT

T2f = RLXANLZ.T2f;
T2s = RLXANLZ.T2s;
T2fout = RLXANLZ.T2fout;
T2sout = RLXANLZ.T2sout;
SMNR = RLXANLZ.SMNR;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
TEarr = RLXANLZ.TEarr

%-----------------------------------------------------
% Calc
%-----------------------------------------------------
T2fstd = std(T2fout,0,3);
T2sstd = std(T2sout,0,3);
for n = 1:length(T2f)
    Sig(n,:) = 0.6*exp(-TEarr/T2f(n)) + 0.4*exp(-TEarr/T2s);
    rT2fstd(n,:) = T2fstd(n,:)/T2f(n);
    rT2sstd(n,:) = T2sstd(n,:)/T2s;
end

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
for n = 1:length(T2f)
    figure(9); hold on;
    plot(TEarr,Sig(n,:),'r*-');
    figure(10); hold on;
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
for n = 1:length(T2f)
    reqSMNRT2f(n) = interp1(rT2fstd(n,:),SMNR,rel);
    reqSMNRT2s(n) = interp1(rT2sstd(n,:),SMNR,rel);    
end
figure(11); hold on;
plot(T2f,reqSMNRT2f,'k');
plot(T2f,reqSMNRT2s,'b');
ylabel('Required SMNR');
xlabel('T2f');
legend('for T2f','for T2s');

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