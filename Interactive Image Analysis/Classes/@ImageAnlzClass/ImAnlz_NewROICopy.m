%============================================
% New_ROI
%============================================
function IMAGEANLZ = ImAnlz_NewROICopy(IMAGEANLZ,CURRENTROI,TEMPROI)

%---------------------------------------------
% Create
%---------------------------------------------
IMAGEANLZ.GETROIS = 1;
IMAGEANLZ.CURRENTROI = ImageRoiClass(IMAGEANLZ);
IMAGEANLZ.TEMPROI = ImageRoiClass(IMAGEANLZ);

IMAGEANLZ.CURRENTROI.CopyRoiInfo(CURRENTROI);
IMAGEANLZ.TEMPROI.CopyRoiInfo(TEMPROI);

IMAGEANLZ.buttonfunction = 'CreateROI';
IMAGEANLZ.movefunction = '';
IMAGEANLZ.pointer = IMAGEANLZ.TEMPROI.GetPointer;

IMAGEANLZ.FIGOBJS.MakeCurrentVisible;

Status(1).state = 'busy';
Status(1).string = 'ROI Active';       
Status(2).state = 'busy';  
Status(2).string = IMAGEANLZ.TEMPROI.GetStatus;   
Status(3).state = 'info';  
Status(3).string = IMAGEANLZ.TEMPROI.GetInfo;        
IMAGEANLZ.STATUS.SetStatus(Status)



