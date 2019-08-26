%======================================================
% 
%======================================================

function [PLOT,err] = PLOT_MEOVatTroSnrArr_v1a_Func(PLOT,INPUT)

Status('busy','Plot MEOV @ Tro-SNR relationship');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ANLZ = INPUT.ANLZ;
clear INPUT

%rsnrArr = ANLZ.rsnrArr

%---------------------------------------------
% Vars
%---------------------------------------------
ANLZoutArr = ANLZ.ANLZoutArr;
TroArr = ANLZ.TroArr;

%TroArr = [TroArr(1:3) TroArr(5:end)];                           % Tro8 - weird iSeg
%ANLZoutArr = [ANLZoutArr(1:3,:);ANLZoutArr(5:end,:)];

sz = size(ANLZoutArr);
for n = 1:sz(1)
    for m = 1:sz(2)
        meov(n,m) = ANLZoutArr(n,m).meov;
        snr(n,m) = ANLZoutArr(n,m).snr;
        vox(n,m) = ANLZoutArr(n,m).vox;
        froi(n,m) = ANLZoutArr(n,m).nroi/ANLZoutArr(n,m).nob;
        nob(n,m) = ANLZoutArr(n,m).nob;
    end
end

for n = 1:sz(1)
    %ivox = logspace(log10(16),log10(256),33);
    ivox = logspace(log10(32),log10(512),33);
    [snr0,inds] = unique(snr(n,:));
    isnr(n,:) = interp1(vox(n,inds),snr(n,inds),ivox,'pchip','extrap');
    figure(123145); hold on;    
    plot(ivox,isnr(n,:),'-');
    h = gca;
    h.XScale = 'log';
    %h.XLim = [16 256];
    h.XLim = [32 512];
    %h.XTick = round(logspace(log10(16),log10(256),9)*10)/10;
    h.XTick = round(logspace(log10(32),log10(512),9)*10)/10;
end

for n = 1:length(ivox)
    %itro = 3:1:27;
    itro = 1:0.25:4;
    isnr2(:,n) = interp1(TroArr,isnr(:,n),itro,'pchip','extrap');
end
isnr2 = permute(isnr2,[2 1]);
isnr2 = flip(isnr2,1);

%---------------------------------------------
% Plot
%---------------------------------------------
fhand = figure(800);
ihand = image(isnr2/2);
ihand.CDataMapping = 'scaled';
colorbar;
ahand = gca;
ahand.XTick = (1:6:30);
ahand.XTickLabel = (3:6:30);
%ahand.XTick = (1:4:16);
%ahand.XTickLabel = (1:1:4);
ahand.YTick = linspace(1,33,5);
%ahand.YTickLabel = flip(logspace(log10(16),log10(256),5));
ahand.YTickLabel = flip(logspace(log10(32),log10(512),5)); 
ahand.CLim = [0 40];
fhand.Position = [700 400 300 180];


for n = 1:sz(1)
    isnr = logspace(log10(4),log10(2/ANLZ.rnei),33);
    [snr0,inds] = unique(snr(n,:));
    imeov(n,:) = interp1(snr(n,inds),meov(n,inds),isnr,'pchip','extrap');
    ifroi(n,:) = interp1(snr(n,inds),froi(n,inds),isnr,'pchip','extrap');
    ivox(n,:) = interp1(snr(n,inds),vox(n,inds),isnr,'pchip','extrap');
    inob(n,:) = interp1(snr(n,inds),nob(n,inds),isnr,'pchip','extrap');
    
    figure(1234); hold on;    
    plot(snr(n,:),meov(n,:),'*');
    plot(isnr,imeov(n,:));
    h = gca;
    h.XScale = 'log';
    h.XLim = [4 2/ANLZ.rnei];
    h.XTick = round(logspace(log10(4),log10(2/ANLZ.rnei),9)*10)/10;
    
    figure(1235); hold on;    
    plot(snr(n,:),vox(n,:),'*');
    plot(isnr,ivox(n,:));
    h = gca;
    h.XScale = 'log';
    h.XLim = [4 2/ANLZ.rnei];
    h.XTick = round(logspace(log10(4),log10(2/ANLZ.rnei),9)*10)/10;

    figure(1236); hold on;    
    plot(snr(n,:),nob(n,:),'*');
    plot(isnr,inob(n,:));
    h = gca;
    h.XScale = 'log';
    h.XLim = [4 2/ANLZ.rnei];
    h.XTick = round(logspace(log10(4),log10(2/ANLZ.rnei),9)*10)/10;         
end

for n = 1:length(isnr)
    itro = 3:1:27;
    %itro = 1:0.25:4;
    imeov2(:,n) = interp1(TroArr,imeov(:,n),itro,'pchip','extrap');
    ifroi2(:,n) = interp1(TroArr,ifroi(:,n),itro,'pchip','extrap');
    inob2(:,n) = interp1(TroArr,inob(:,n),itro,'pchip','extrap');    
    ivox2(:,n) = interp1(TroArr,ivox(:,n),itro,'pchip','extrap');        
end
imeov2 = permute(imeov2,[2 1]);
imeov2 = flip(imeov2,1);
ifroi2 = permute(ifroi2,[2 1]);
ifroi2 = flip(ifroi2,1);
inob2 = permute(inob2,[2 1]);
inob2 = flip(inob2,1);
ivox2 = permute(ivox2,[2 1]);
ivox2 = flip(ivox2,1);

%---------------------------------------------
% Plot
%---------------------------------------------
fhand = figure(999); 
%ihand = image(imeov2);
ihand = image(imeov2*2);
ihand.CDataMapping = 'scaled';
colorbar;
ahand = gca;
ahand.XTick = (1:6:30);
ahand.XTickLabel = (3:6:30);
%ahand.XTick = (1:4:16);
%ahand.XTickLabel = (1:1:4);
ahand.YTick = linspace(1,33,5);
ahand.YTickLabel = flip(logspace(log10(4),log10(2/ANLZ.rnei),5)); 
%ahand.CLim = [3500 8000];
%ahand.CLim = [5400 9000];
fhand.Position = [700 400 300 180];

%---------------------------------------------
% Plot
%---------------------------------------------
fhand = figure(1000);
ihand = image(ifroi2);
ihand.CDataMapping = 'scaled';
colorbar;
ahand = gca;
ahand.XTick = (1:6:30);
ahand.XTickLabel = (3:6:30);
%ahand.XTick = (1:4:16);
%ahand.XTickLabel = (1:1:4);
ahand.YTick = linspace(1,33,5);
ahand.YTickLabel = flip(logspace(log10(4),log10(2/ANLZ.rnei),5)); 
ahand.CLim = [0 1];
fhand.Position = [700 400 300 180];

%---------------------------------------------
% Plot
%---------------------------------------------
fhand = figure(1001);
ihand = image(ivox2*2);
ihand.CDataMapping = 'scaled';
colorbar;
ahand = gca;
ahand.XTick = (1:6:30);
ahand.XTickLabel = (3:6:30);
%ahand.XTick = (1:4:16);
%ahand.XTickLabel = (1:1:4);
ahand.YTick = linspace(1,33,5);
ahand.YTickLabel = flip(logspace(log10(4),log10(2/ANLZ.rnei),5)); 
ahand.CLim = [0 250];
fhand.Position = [700 400 300 180];

%load ColorMap5
%colormap(mycolormap);

%---------------------------------------------
% Return
%---------------------------------------------  
PLOT.ExpDisp = '';

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);