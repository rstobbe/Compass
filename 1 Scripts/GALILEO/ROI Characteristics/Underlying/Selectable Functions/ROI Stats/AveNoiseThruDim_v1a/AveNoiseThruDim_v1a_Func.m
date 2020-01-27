%=========================================================
% 
%=========================================================

function [FIT,err] = AveNoiseThruDim_v1a_Func(FIT,INPUT)

Status2('busy','Roi Through Dimension',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ROI = INPUT.ROI;
IMAGEANLZ = INPUT.IMAGEANLZ;
clear INPUT

%---------------------------------------------
% Get Image
%---------------------------------------------
sz = IMAGEANLZ.GetBaseImageSize([]);
Len = sz(4);
%Len = sz(4)-1;

if Len == 1
    err.flag = 1;
    err.msg = 'Not arrayed image';
    return
end

for n = 1:Len
    IMAGEANLZ.SetDim4(n);
    RoiData(:,n) = abs(ROI.GetComplexROIDataArray(IMAGEANLZ));    
end

for m = 1:length(RoiData(:,1))
    Dist = fitdist(RoiData(m,:).',FIT.distribution);
    if m == 1
        figure(2346236);
        histogram(RoiData(1,:));
    end
    if strcmp(FIT.distribution,'Rayleigh')
        Val(m) = Dist.B;
        Mean(m) = 0;
    elseif strcmp(FIT.distribution,'Normal')
        Val(m) = Dist.sigma;
        Mean(m) = Dist.mu;
    end
    if rem(m,1000) == 1
        Status2('busy',['Voxel Number: ',num2str(m)],3);
    end
end

figure(1123503);
histogram(Val,500);

MeanMean = mean(Mean)
MeanNoise = mean(Val)
SNR = MeanMean/MeanNoise


FIT.ExpDisp = '';
FIT.saveable = 'no';
FIT.label = '';

Status2('done','',2);
Status2('done','',3);
