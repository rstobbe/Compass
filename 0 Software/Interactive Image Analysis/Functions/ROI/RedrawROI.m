%============================================
% RedrawROI
%============================================
function RedrawROI(tab,axnum)

global IMAGEANLZ

TempRoi = ImageRoiClass(IMAGEANLZ.(tab)(axnum));

CurrentRoi = IMAGEANLZ.(tab)(axnum).CURRENTROI;


