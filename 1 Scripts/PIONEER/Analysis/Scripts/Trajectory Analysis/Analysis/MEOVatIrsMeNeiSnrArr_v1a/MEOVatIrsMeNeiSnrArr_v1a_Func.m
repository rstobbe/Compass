%======================================================
% 
%======================================================

function [ANLZ,err] = MEOVatIrsMeNeiSnrArr_v1a_Func(ANLZ,INPUT)

Status('busy','Calculate MEOV @ IRS with Minimum Edge and rNEI across SNR Array');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
TF = INPUT.TF; 
PSD = INPUT.PSD; 
OB = INPUT.OB;
zf = ANLZ.zf;
clear INPUT

%---------------------------------------------
% Find Lower Bound
%---------------------------------------------    
INPUT.func = 'FindLB';
INPUT.TF = TF;
INPUT.PSD = PSD;
INPUT.OB = OB;
ANLZ.zf = 256;
%lb = 15;
lb = 11.2;
dir = 1;
while true
    [meov0,ANLZout] = MEOVatIrsMeNeiSnrArr_v1a_Reg(lb,ANLZ,INPUT);
    if dir == 1 && meov0 == 0
        lb = lb+0.5;
    elseif dir == 1 && meov0 == 1
        if strcmp(ANLZ.pointsrcfind,'No')
            lb = lb + 0.25;
            break
        end
        ANLZ.zf = 512;
        dir = 2;
    elseif dir == 2 && meov0 == 1
        lb = lb-0.1;
    elseif dir == 2 && meov0 == 0        
        ANLZ.zf = 768;
        dir = 3;
    elseif dir == 3 && meov0 == 0
        lb = lb+0.025;
    elseif dir == 3 && meov0 == 1      
        break
    end
end

%---------------------------------------------
% Build SNR Estimation Array
%--------------------------------------------- 
ANLZ.zf = zf;
V = [lb lb+3 lb+8 lb+20];
INPUT.func = 'FindMeov';
for p = 1:4
    [meov(p),ANLZoutArr(p)] = MEOVatIrsMeNeiSnrArr_v1a_Reg(V(p),ANLZ,INPUT);
    snr(p) = ANLZoutArr(p).snr;
    froi(p) = ANLZoutArr(p).froi;
    cv(p) = ANLZoutArr(p).cv;
    siv(p) = ANLZoutArr(p).siv;
    aveirsout(p) = ANLZoutArr(p).aveirsout;
    meout(p) = ANLZoutArr(p).meout;
end
figure(100); clf; hold on;
isnr = logspace(log10(4),log10(1.6/ANLZ.rnei),ANLZ.solpnts);
%iV = interp1(snr,V,isnr,'pchip','extrap');             % not useful
iV = interp1(snr,V,isnr,'pchip',0);
isnr = isnr(iV~=0);
iV = iV(iV~=0);
plot(V,snr,'*');
plot(iV,isnr,'*');
xlabel('Object Function Value');
ylabel('SNR');
title('Solution Points')

%---------------------------------------------
% Test
%---------------------------------------------
for p = 1:length(iV)
    [meov(p+4),ANLZoutArr(p+4)] = MEOVatIrsMeNeiSnrArr_v1a_Reg(iV(p),ANLZ,INPUT);
    snr(p+4) = ANLZoutArr(p+4).snr;
    froi(p+4) = ANLZoutArr(p+4).froi;
    cv(p+4) = ANLZoutArr(p+4).cv;
    siv(p+4) = ANLZoutArr(p+4).siv;
    aveirsout(p+4) = ANLZoutArr(p+4).aveirsout;
    meout(p+4) = ANLZoutArr(p+4).meout;
end
[b,inds] = sort(snr);
snr = snr(inds);
meov = meov(inds);
froi = froi(inds);
cv = cv(inds);
siv = siv(inds);

%---------------------------------------------
% Plot
%---------------------------------------------
figure(1234); hold on;
plot(snr,meov,'-*');
ylabel('MEOV (mm3)');
xlabel('SNR');

figure(1235); hold on;
plot(snr,froi,'-*');
ylabel('fROI');
xlabel('SNR');

figure(1236); hold on;
plot(snr,cv,'-*');
ylabel('CV');
xlabel('SNR');

figure(1237); hold on;
plot(snr,siv,'-*');
ylabel('SIV');
xlabel('SNR');

figure(1238); hold on;
plot(snr,aveirsout,'-*');
ylabel('IRS');
xlabel('SNR');

figure(1239); hold on;
plot(snr,meout,'-*');
ylabel('ME');
xlabel('SNR');

MinMeov = min(meov);
BestSNR = snr(meov == MinMeov);
fROIatBest = froi(meov == MinMeov);

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'',[],'Output'};
Panel(2,:) = {ANLZ.method,'','Output'};
Panel(3,:) = {'TF',INPUT.TF.name,'Output'};
Panel(4,:) = {'PSD',INPUT.PSD.name,'Output'};
Panel(5,:) = {'IRS',ANLZ.aveirs,'Output'};
Panel(6,:) = {'ME',ANLZ.me,'Output'};
Panel(7,:) = {'rNEI',ANLZ.rnei,'Output'};
Panel(8,:) = {'Min MEOV (mm3)',MinMeov,'Output'};
Panel(9,:) = {'fROI at Best SNR',fROIatBest,'Output'};
Panel(10,:) = {'Best SNR',BestSNR,'Output'};

ANLZ.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ANLZ.ExpDisp = PanelStruct2Text(ANLZ.PanelOutput);
ANLZ.ANLZoutArr = ANLZoutArr;
ANLZ.snr = snr;
ANLZ.meov = meov;
ANLZ.froi = froi;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

