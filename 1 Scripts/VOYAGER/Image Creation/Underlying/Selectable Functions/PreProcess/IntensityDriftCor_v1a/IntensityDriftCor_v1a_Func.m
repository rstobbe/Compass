%=====================================================
%
%=====================================================

function [IDC,err] = IntensityDriftCor_v1a_Func(IDC,INPUT)

Status2('busy','Correct for Intensity Drift',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FIDmat = INPUT.FIDmat;
split = INPUT.split;
visuals = INPUT.visuals;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if split == 1
    error()
end
sz = size(FIDmat);

%---------------------------------------------
% Plot Variation
%---------------------------------------------
if strcmp(visuals,'Yes')
    figure(1200); hold on;
    plot(abs(real(squeeze(FIDmat(1,1,1,:)))),'r');
    plot(abs(imag(squeeze(FIDmat(1,1,1,:)))),'b');
    plot(abs(squeeze(FIDmat(1,1,1,:))),'g');
    xlabel('Split Number'); ylabel('First Point of Split Intensity'); title('Intensity Drift');
    ylim([0 1.1*max(abs(FIDmat(:)))]);
end

%---------------------------------------------
% Record Variation
%---------------------------------------------
test1 = min(abs(squeeze(FIDmat(1,1,1,:))));
test2 = max(abs(squeeze(FIDmat(1,1,1,:))));
IDC.meanAbs = (test1+test2)/2;
IDC.rAbsVar = abs((test1-test2)/((test1+test2)/2));
test1 = min(real(squeeze(FIDmat(1,1,1,:))));
test2 = max(real(squeeze(FIDmat(1,1,1,:))));
IDC.meanReal = (test1+test2)/2;
IDC.rRealVar = abs((test1-test2)/((test1+test2)/2));
test1 = min(imag(squeeze(FIDmat(1,1,1,:))));
test2 = max(imag(squeeze(FIDmat(1,1,1,:))));
IDC.meanImag = (test1+test2)/2;
IDC.rImagVar = abs((test1-test2)/((test1+test2)/2));

%---------------------------------------------
% Drift Correction
%---------------------------------------------
Cor = mean(squeeze(FIDmat(1,1,1,:)))./squeeze(FIDmat(1,1,1,:));
[~,~,CorMat] = meshgrid((1:sz(2)),1:sz(1),Cor);

for n = 1:sz(3)
    %for m = 1:sz(2)
    %    for p = 1:sz(3)
    %        FIDmat(n,m,p,:) = squeeze(FIDmat(n,m,p,:)).*Cor;
    %    end
    %end
    FIDmat(:,:,n,:) = squeeze(FIDmat(:,:,n,:)).*CorMat;
end

%---------------------------------------------
% Plot Variation
%---------------------------------------------
if strcmp(visuals,'Yes')
    figure(1200); hold on;
    plot(abs(real(squeeze(FIDmat(1,1,1,:)))),'k');
    plot(abs(imag(squeeze(FIDmat(1,1,1,:)))),'k');
    plot(abs(squeeze(FIDmat(1,1,1,:))),'k');
end

IDC.FIDmat = FIDmat;

Status2('done','',2);
Status2('done','',3);






