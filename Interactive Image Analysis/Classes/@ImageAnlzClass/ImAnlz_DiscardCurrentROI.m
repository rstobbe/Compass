%============================================
% Discard ROI
%============================================
function IMAGEANLZ = ImAnlz_DiscardCurrentROI(IMAGEANLZ)

%---------------------------------------------
% Discard
%---------------------------------------------
IMAGEANLZ.GETROIS = 0;
IMAGEANLZ.redrawroi = 0;
IMAGEANLZ.androi = 0;
IMAGEANLZ.TEMPROI = ImageRoiClass.empty;
IMAGEANLZ.CURRENTROI = ImageRoiClass.empty;
IMAGEANLZ.REDRAWROI = ImageRoiClass.empty;
IMAGEANLZ.ANDROI = ImageRoiClass.empty;

IMAGEANLZ.buttonfunction = '';
IMAGEANLZ.movefunction = '';
IMAGEANLZ.pointer = 'arrow';
IMAGEANLZ.roievent = 'Add';
set(gcf,'pointer',IMAGEANLZ.pointer);





