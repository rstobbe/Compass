%====================================================
%  
%====================================================

function [RSZ,err] = ReSizeReconPars_v1a_Func(RSZ,INPUT)

Status2('busy','Resize Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ReconPars1 = INPUT.ReconPars0;
ReconPars2 = INPUT.ReconPars1;
Im = INPUT.Im;
beta = RSZ.beta;
clear INPUT;

%---------------------------------------------
% Info
%---------------------------------------------
ImfovTB2 = ReconPars2.ImfovTB;
ImfovLR2 = ReconPars2.ImfovLR;
ImfovIO2 = ReconPars2.ImfovIO;

%---------------------------------------------
% Remove NaN 
%---------------------------------------------
Im(isnan(Im)) = 0;


error('finish')    % add test for match etc...


%---------------------------------------------
% Match FoV
%---------------------------------------------
rTB = ReconPars1.ImfovTB/ImfovTB2;
rLR = ReconPars1.ImfovLR/ImfovLR2;
rIO = ReconPars1.ImfovIO/ImfovIO2;
matTB = round(rTB*x2/2)*2;
matLR = round(rLR*y2/2)*2;
matIO = round(rIO*z2/2)*2;
ReconPars2 = ReconPars1;
ReconPars2.ImfovTB_act = (matTB/x2)*ImfovTB2;
ReconPars2.ImfovLR_act = (matLR/x2)*ImfovLR2;
ReconPars2.ImfovIO_act = (matIO/x2)*ImfovIO2;
if matTB <= x2
    bTB2 = 1; tTB2 = matTB;
    bTB1 = (x2-matTB)/2+1; tTB1 = (x2+matTB)/2;    
else
    bTB2 = (matTB-x2)/2+1; tTB2 = (matTB+x2)/2;
    bTB1 = 1; tTB1 = x2;
end
if matLR <= y2
    bLR2 = 1; tLR2 = matLR;
    bLR1 = (y2-matLR)/2+1; tLR1 = (y2+matLR)/2;    
else
    bLR2 = (matLR-y2)/2+1; tLR2 = (matLR+y2)/2;
    bLR1 = 1; tLR1 = y2;
end
if matIO <= z2
    bIO2 = 1; tIO2 = matIO;
    bIO1 = (z2-matIO)/2+1; tIO1 = (z2+matIO)/2;    
else
    bIO2 = (matIO-z2)/2+1; tIO2 = (matIO+z2)/2;
    bIO1 = 1; tIO1 = z2;
end
rszIm = zeros(matTB,matLR,matIO);
rszIm(bTB2:tTB2,bLR2:tLR2,bIO2:tIO2) = Im2(bTB1:tTB1,bLR1:tLR1,bIO1:tIO1);

%---------------------------------------------
% Match Matrix
%---------------------------------------------
FTrszIm = fftshift(ifftn(ifftshift(rszIm)));
[xt,yt,zt] = size(FTrszIm);
if x1 <= xt
    bTBn = 1; tTBn = x1;
    bTBt = (xt-x1)/2+1; tTBt = (xt+x1)/2;
else
    bTBn = (x1-xt)/2+1; tTBn = (x1+xt)/2;
    bTBt = 1; tTBt = xt;    
end
if y1 <= yt
    bLRn = 1; tLRn = y1;
    bLRt = (yt-y1)/2+1; tLRt = (yt+y1)/2;
else
    bLRn = (y1-yt)/2+1; tLRn = (y1+yt)/2;
    bLRt = 1; tLRt = yt;    
end
if z1 <= zt
    bIOn = 1; tIOn = z1;
    bIOt = (zt-z1)/2+1; tIOt = (zt+z1)/2;
else
    bIOn = (z1-zt)/2+1; tIOn = (z1+zt)/2;
    bIOt = 1; tIOt = zt;    
end
FTnew = zeros(x1,y1,z1);
FTnew(bTBn:tTBn,bLRn:tLRn,bIOn:tIOn) = FTrszIm(bTBt:tTBt,bLRt:tLRt,bIOt:tIOt);

%---------------------------------------------
% Filter
%---------------------------------------------
Filt = Kaiser_v1b(x1,y1,z1,beta,'unsym');
Im = fftshift(fftn(ifftshift(FTnew.*Filt)));

ReconPars2.ImvoxTB_act = ReconPars2.ImfovTB_act/x1;
ReconPars2.ImvoxLR_act = ReconPars2.ImfovLR_act/y1;
ReconPars2.ImvoxIO_act = ReconPars2.ImfovIO_act/z1;

IMG2.Im = Im;
IMG2.ReconPars = ReconPars2;
RSZ.IMG = IMG2;


Status2('done','',2);
Status2('done','',3);

