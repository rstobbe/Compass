%=========================================================
% 
%=========================================================

function [FIT,err] = NoiseSdvThruDim_v1a_Func(FIT,INPUT)

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
    Data = abs(ROI.GetComplexROIDataArray(IMAGEANLZ));  
    Dist = fitdist(Data,'Rayleigh');
    Val1(n) = Dist.B;
    Dist = fitdist(Data,'Normal');
    Val2(n) = Dist.sigma;
%     Dist = fitdist(Data,'Rician');
%     Val3(n) = Dist.sigma;
%     Val4(n) = Dist.s;
end

MeanRayleigh = mean(Val1)

Slope = [ones(Len,1) (0:Len-1).']\Val1.'

figure(1123503); hold on;
plot(Val1);
plot((0:Len-1),Slope(1)+(0:Len-1)*Slope(2),'k');
figure(1123504);
plot(Val2);
% figure(1123505);
% plot(Val3);
% figure(1123506);
% plot(Val4);


FIT.ExpDisp = '';
FIT.saveable = 'no';
FIT.label = '';

Status2('done','',2);
Status2('done','',3);
