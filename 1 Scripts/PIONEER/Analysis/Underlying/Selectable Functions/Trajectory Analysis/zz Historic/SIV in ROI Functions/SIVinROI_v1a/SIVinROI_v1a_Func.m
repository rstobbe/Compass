%==============================================
% 
%==============================================

function [SIV,err] = SIVinROI_v1a_Func(SIV,INPUT)

Status2('busy','Find SIV in ROI',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
ROI = INPUT.ROI;
PSD = INPUT.PSD;
Nroi = INPUT.Nroi;
vinvox = INPUT.vinvox;
psddiam = INPUT.psddiam;
clear INPUT

%---------------------------------------------
% CV conv meth (same result as FT meth)
%---------------------------------------------
%R = fftshift(ifftn(ifftshift(PSD)));
%subROI = ROI(ZF/2-10:ZF/2+10,ZF/2-10:ZF/2+10,ZF/2-10:ZF/2+10);
%figure(1001); hold on; plot(squeeze(subROI(:,11,11))); plot(squeeze(subROI(11,11,:))); plot(squeeze(subROI(11,:,11)));
%if sum(subROI(:)) ~= vinROI
%    error();
%end
%roiconv = convn(subROI,R,'same');
%maskroiconv = subROI.*roiconv;
%CVarr(j) = (PSD_diam^3/sum(PSD(:)))*(sum(maskroiconv(:))/vinROI);

%---------------------------------------------
% CV FT meth
%---------------------------------------------
A = fftshift(fftn(ROI));
A = A.*PSD;
A = ifftn(ifftshift(A));
A = abs(A);
AROI = A(logical(ROI));
vinROI = Nroi*vinvox;
SIV.CV = (psddiam^3/sum(PSD(:)))*(sum(AROI(:))./vinROI);
SIV.SIV = Nroi/SIV.CV; 


