%=========================================================
% 
%=========================================================

function [TST,err] = T1_CNRopt_v1a_Func(TST,INPUT)

Status2('busy','Contrast to Noise Optimization',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
T1 = INPUT.T1;
clear INPUT;

%---------------------------------------------
% Run1
%---------------------------------------------
TR = 5:5:2000;
flip = 0.25:0.25:90;
sig = [];
for n = 1:2
    top = sin((pi*flip/180).')*(1-exp(-TR/T1(n)));
    bot = 1 - cos((pi*flip/180).')*exp(-TR/T1(n));
    sig(:,:,n) = top./bot;
end
rNoise = repmat(TR.^0.5,length(flip),1);

figure(100);
SNR1 = sig(:,:,1)./rNoise;
subplot(2,2,1);
imshow(SNR1/(max(SNR1(:))));
colormap('jet');

SNR2 = sig(:,:,2)./rNoise;
subplot(2,2,2);
imshow(SNR2/(max(SNR2(:))));
colormap('jet');

CNR = (sig(:,:,2)-sig(:,:,1))./rNoise;
subplot(2,2,3);
imshow(CNR/(max(CNR(:))),[0.8 1]);
colormap('jet');

Rel = sig(:,:,2)./sig(:,:,1);
subplot(2,2,4);
imshow(Rel/(max(Rel(:))),[0.8 1]);
colormap('jet');

%---------------------------------------------
% Run2
%---------------------------------------------
TR = 5:0.5:200;
flip = 0.25:0.25:90;
sig = [];
for n = 1:2
    top = sin((pi*flip/180).')*(1-exp(-TR/T1(n)));
    bot = 1 - cos((pi*flip/180).')*exp(-TR/T1(n));
    sig(:,:,n) = top./bot;
end
rNoise = repmat(TR.^0.5,length(flip),1);

figure(101);
SNR1 = sig(:,:,1)./rNoise;
subplot(2,2,1);
imshow(SNR1/(max(SNR1(:))));
colormap('jet');

SNR2 = sig(:,:,2)./rNoise;
subplot(2,2,2);
imshow(SNR2/(max(SNR2(:))));
colormap('jet');

CNR = (sig(:,:,2)-sig(:,:,1))./rNoise;
subplot(2,2,3);
imshow(CNR/(max(CNR(:))),[0.8 1]);
colormap('jet');

Rel = sig(:,:,2)./sig(:,:,1);
subplot(2,2,4);
imshow(Rel/(max(Rel(:))),[0.8 1]);
colormap('jet');

%---------------------------------------------
% Run3
%---------------------------------------------
TR = 3:0.02:15;
flip = 0.1:0.05:30;
testTR = 4;
testflip = 9;
ind1 = find(TR == testTR);
ind2 = find(flip == testflip);
ernst1 = (180/pi)*acos(exp(-testTR/T1(1)))
ernst2 = (180/pi)*acos(exp(-testTR/T1(2)))

sig = [];
for n = 1:2
    top = sin((pi*flip/180).')*(1-exp(-TR/T1(n)));
    bot = 1 - cos((pi*flip/180).')*exp(-TR/T1(n));
    sig(:,:,n) = top./bot;
end
rNoise = repmat(TR.^0.5,length(flip),1);

figure(102);
SNR1 = sig(:,:,1)./rNoise;
subplot(2,2,1); hold on;
imshow(SNR1/(max(SNR1(:))));
colormap('jet');
plot(ind1,ind2,'w*');

SNR2 = sig(:,:,2)./rNoise;
subplot(2,2,2); hold on;
imshow(SNR2/(max(SNR2(:))));
colormap('jet');
plot(ind1,ind2,'w*');

CNR = (sig(:,:,2)-sig(:,:,1))./rNoise;
subplot(2,2,3); hold on;
imshow(CNR/(max(CNR(:))),[0.9 1]);
colormap('jet');
plot(ind1,ind2,'w*');

Rel = (sig(:,:,2)-sig(:,:,1))./sig(:,:,1);
%test = max(Rel(:))
subplot(2,2,4); hold on;
imshow(Rel);
colormap('jet');
plot(ind1,ind2,'w*');

Status2('done','',2);
Status2('done','',3);


