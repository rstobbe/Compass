%=========================================================
% 
%=========================================================

function [FIT,err] = RoiThroughDimension_v1a_Func(FIT,INPUT)

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
    ROI_AbsAve(n) = mean(abs(ROI.GetComplexROIDataArray(IMAGEANLZ)));
    ROI_CplxAve(n) = mean(ROI.GetComplexROIDataArray(IMAGEANLZ));
    ROI_AbsCplxAve(n) = abs(mean(ROI.GetComplexROIDataArray(IMAGEANLZ)));
end

MeanAbsAveRoi = mean(ROI_AbsAve)
ROI_ArrRel = ROI_AbsAve/MeanAbsAveRoi;

Slope = [ones(Len,1) (0:Len-1).']\ROI_ArrRel.'
mdl = fitlm((0:Len-1),ROI_ArrRel);
[b,bint,r,rint,stats] = regress(ROI_ArrRel.',[ones(Len,1) (0:Len-1).']);

figure(12341234); hold on;
plot((0:Len-1),ROI_ArrRel,'m');
plot((0:Len-1),Slope(1)+(0:Len-1)*Slope(2),'k');
xlabel('Scan Number');
ylabel('Relative Signal');
%ylim([0.99 1.01]);
ylim([0.97 1.03]);

figure(12341235);
subplot(2,3,1); hold on;
plot((0:Len-1),ROI_AbsAve,'m');
plot((0:Len-1),(Slope(1)+(0:Len-1)*Slope(2))*MeanAbsAveRoi,'k');
xlabel('Scan Number');
ylabel('Abs Signal (Abs Ave)');

subplot(2,3,4); hold on;
AbsDiff = ROI_AbsAve(2:2:end) - ROI_AbsAve(1:2:end-1);
plot((1:Len/2),AbsDiff,'m');
plot((1:Len/2),zeros(1,Len/2),'k');
xlabel('Difference Number');
ylabel('Difference Abs Signal (Abs Ave)');
lims = [-ceil(max(abs(AbsDiff))*100)/100 ceil(max(abs(AbsDiff))*100)/100];
ylim(lims);

subplot(2,3,2); hold on;
plot((0:Len-1),real(ROI_CplxAve),'r');
xlabel('Scan Number');
ylabel('Real Signal (Cplx Ave)');

subplot(2,3,5); hold on;
RealDiff = real(ROI_CplxAve(2:2:end)) - real(ROI_CplxAve(1:2:end-1));
plot((1:Len/2),RealDiff,'r');
plot((1:Len/2),zeros(1,Len/2),'k');
xlabel('Difference Number');
ylabel('Difference Real Signal (Cplx Ave)');
ylim(lims);

subplot(2,3,3); hold on;
plot((0:Len-1),imag(ROI_CplxAve),'b');
xlabel('Scan Number');
ylabel('Imaginary Signal (Cplx Ave)');

subplot(2,3,6); hold on;
ImagDiff = imag(ROI_CplxAve(2:2:end)) - imag(ROI_CplxAve(1:2:end-1));
plot((1:Len/2),ImagDiff,'b');
plot(1:Len/2,zeros(1,Len/2),'k');
xlabel('Difference Number');
ylabel('Difference Imaginary Signal (Cplx Ave)');
ylim(lims);

figure(12341236); 
subplot(1,3,1); hold on;
Angle = unwrap(angle(ROI_CplxAve));
plot((0:Len-1),Angle,'g');
type = 'poly1';
fitobject = fit((0:Len-1).',unwrap(angle(ROI_CplxAve)).',type);
out = fitobject((0:Len-1));
plot((0:Len-1),out,'k');
xlabel('Scan Number');
ylabel('Phase');

subplot(1,3,2); hold on;
ROI_CplxAveFix = ROI_CplxAve.*exp(-1i.*out).';
FixedAngle = unwrap(angle(ROI_CplxAveFix));
plot((0:Len-1),FixedAngle,'g');
type = 'poly1';
fitobject = fit((0:Len-1).',unwrap(angle(ROI_CplxAveFix)).',type);
out = fitobject((0:Len-1));
plot((0:Len-1),out,'k');
xlabel('Scan Number');
ylabel('Corrected Phase');

subplot(1,3,3); hold on;
FixedAngleDif = FixedAngle(2:2:end) - FixedAngle(1:2:end);
plot((1:Len/2),FixedAngleDif,'k');
plot(1:Len/2,zeros(1,Len/2),'k');
xlabel('Difference Number');
ylabel('Difference Corrected Phase');
% lims = [-ceil(max(abs(RealDiff))*100)/100 ceil(max(abs(RealDiff))*100)/100];
% ylim(lims);

Pdgm = zeros(1,50);
Pdgm(2:2:end) = 1;
[R,P] = corrcoef(FixedAngle,Pdgm)
[R,P] = corrcoef(Angle,Pdgm)

figure(12341237);
subplot(2,2,1); hold on;
plot((0:Len-1),real(ROI_CplxAveFix),'r');
xlabel('Scan Number');
ylabel('Real Signal (Cplx Ave PhaseCor)');

subplot(2,2,3); hold on;
RealDiff = real(ROI_CplxAveFix(2:2:end)) - real(ROI_CplxAveFix(1:2:end-1));
plot((1:Len/2),RealDiff,'r');
plot(1:Len/2,zeros(1,Len/2),'k');
xlabel('Difference Number');
ylabel('Difference Real Signal (Cplx Ave PhaseCor)');
lims = [-ceil(max(abs(RealDiff))*100)/100 ceil(max(abs(RealDiff))*100)/100];
ylim(lims);

subplot(2,2,2); hold on;
plot((0:Len-1),imag(ROI_CplxAveFix),'b');
xlabel('Scan Number');
ylabel('Imaginary Signal (Cplx Ave PhaseCor)');

subplot(2,2,4); hold on;
ImagDiff = imag(ROI_CplxAveFix(2:2:end)) - imag(ROI_CplxAveFix(1:2:end-1));
plot((1:Len/2),ImagDiff,'b');
plot(1:Len/2,zeros(1,Len/2),'k');
xlabel('Difference Number');
ylabel('Difference Imaginary Signal (Cplx Ave PhaseCor)');
ylim(lims);

[h,p] = ttest2(RealDiff,ImagDiff)                
[h,p] = vartest2(real(ROI_CplxAveFix),imag(ROI_CplxAveFix))                                         % two-sample F-test                                

FIT.ExpDisp = '';
FIT.saveable = 'no';
FIT.label = '';

Status2('done','',2);
Status2('done','',3);
