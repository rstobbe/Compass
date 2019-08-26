%=========================================================
% 
%=========================================================

function [ROIANLZ,err] = DtiSnrMapSarah_v1a_Func(ROIANLZ,INPUT)

Status('busy','Create SNR Map from Sarahs DTI Data');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMAGEANLZ = INPUT.IMAGEANLZ;
tab = INPUT.tab;
clear INPUT

%---------------------------------------------
% Standard Deviation
%---------------------------------------------
imsize = IMAGEANLZ.GetBaseImageSize([]);
Dim4Size = imsize(4);

Im = zeros(imsize(1),imsize(2),12);
B0nums = (1:11:Dim4Size);

for n = 1:length(B0nums)
    IMAGEANLZ.SetDim4(B0nums(n));
    IMAGEANLZ.SetImage;
    IMAGEANLZ.SetImageSlice;
    Im(:,:,n) = IMAGEANLZ.imslice;
end

fh = figure(1236231);
fh.Name = 'B0 Images';
fh.NumberTitle = 'off';
fh.Position = [400 100 1000 800];
MaxImVal = max(Im(:));
for n = 1:length(B0nums)
    subplot(3,4,n);
    imshow(Im(:,:,n),[0 MaxImVal]);
end
    
StDev = zeros(imsize(1),imsize(2));
for n = 1:imsize(1)
    for m = 1:imsize(2)
        StDev(n,m) = std(Im(n,m,:));
    end
end

fh = figure(1236232);
fh.Name = 'Standard Deviation through B0 Images';
fh.NumberTitle = 'off';
fh.Position = [400 100 1000 800];
subplot(2,2,1);
imshow(StDev,[0 max(StDev(:))])
title('Per Pixel Standard Deviation');

cStDev = conv2(StDev,ones(7),'same');
subplot(2,2,2);
imshow(cStDev,[0 max(cStDev(:))])
title('Smoothed Standard Deviation');

%---------------------------------------------
% Average B500 Values
%---------------------------------------------
Im = zeros(imsize(1),imsize(2),120);
for n = 1:12
    B500nums((n-1)*10+1:(n-1)*10+10) = (n-1)*11+2:(n-1)*11+11;
end

for n = 1:length(B500nums)
    IMAGEANLZ.SetDim4(B500nums(n));
    IMAGEANLZ.SetImage;
    IMAGEANLZ.SetImageSlice;
    Im(:,:,n) = IMAGEANLZ.imslice;
end


Mean500Im = mean(Im,3);
cMean500Im = conv2(Mean500Im,ones(7),'same');
Mean500Im(cMean500Im < 6000) = NaN; 
cMean500Im(cMean500Im < 6000) = NaN;                    % mask

subplot(2,2,3);
imshow(Mean500Im,[0 max(Mean500Im(:))])
title('Per Pixel Mean B500 Image');

subplot(2,2,4);
imshow(cMean500Im,[0 max(cMean500Im(:))])
title('Smoothed Mean B500 Image');

fh = figure(1236233);
fh.Name = 'SNR map';
fh.NumberTitle = 'off';
fh.Position = [400 100 1000 800];
SnrIm = Mean500Im./StDev;
cSnrIm = cMean500Im./cStDev;
subplot(2,1,1);
imshow(SnrIm,[0 10]);
ax = gca;
load('ColorMap4');
colormap(ax,mycolormap);
colorbar;
subplot(2,1,2);
imshow(cSnrIm,[0 10]);
ax = gca;
colormap(ax,mycolormap);
colorbar;

figure(1236234);
load('ColorMap4');
colormap(ax,mycolormap);
colorbar;
imshow(cSnrIm,[0 10]);
ax = gca;
colormap(ax,mycolormap);
colorbar;

ROIANLZ.saveable = 'Yes';
ROIANLZ.ExpDisp = char(13);

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
