%============================================
% Complete ROI
%============================================
function IMAGEANLZ = ImAnlz_CompleteCurrentROI(IMAGEANLZ,roi,roiname)

%---------------------------------------------
% Complete 
%---------------------------------------------
IMAGEANLZ.CreateCurrentROIMask;                         % might have been done previously, but do again just to make sure
IMAGEANLZ.ComputeCurrentROI;

%---------------------------------------------
% Save
%---------------------------------------------
for n = length(IMAGEANLZ.SAVEDROIS):roi-1
    IMAGEANLZ.CreateEmptySavedROIAtEnd;
end
IMAGEANLZ.SAVEDROIS(roi) = IMAGEANLZ.CURRENTROI;
IMAGEANLZ.SAVEDROIS(roi).SetROIName(roiname);

%---------------------------------------------
% Reset
%---------------------------------------------
IMAGEANLZ.GETROIS = 0;
IMAGEANLZ.redrawroi = 0;
IMAGEANLZ.SAVEDROISFLAG = 1;
IMAGEANLZ.TEMPROI = ImageRoiClass.empty;
IMAGEANLZ.CURRENTROI = ImageRoiClass.empty;
IMAGEANLZ.REDRAWROI = ImageRoiClass.empty;

IMAGEANLZ.buttonfunction = '';
IMAGEANLZ.movefunction = '';
IMAGEANLZ.pointer = 'arrow';
IMAGEANLZ.roievent = 'Add';
set(gcf,'pointer',IMAGEANLZ.pointer);



