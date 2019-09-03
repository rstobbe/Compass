%============================================
% Discard ROI
%============================================
function IMAGEANLZ = ImAnlz_DiscardCurrentROI(IMAGEANLZ)

%---------------------------------------------
% Discard
%---------------------------------------------
IMAGEANLZ.GETROIS = 0;
IMAGEANLZ.TEMPROI = ImageRoiClass.empty;
IMAGEANLZ.CURRENTROI = ImageRoiClass.empty;

IMAGEANLZ.buttonfunction = '';
IMAGEANLZ.movefunction = '';
IMAGEANLZ.pointer = 'arrow';
IMAGEANLZ.roievent = 'Add';
set(gcf,'pointer',IMAGEANLZ.pointer);





