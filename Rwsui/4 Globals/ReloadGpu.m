function totgblnum = ReloadGpu(totgblnum)

global TOTALGBL

%----------------------------------------------------
% Update TOTALGBL
%----------------------------------------------------
Image = TOTALGBL(2,totgblnum);
Image{1}.Im = gpuArray(Image{1}.ImRam);
TOTALGBL(2,totgblnum) = Image;

