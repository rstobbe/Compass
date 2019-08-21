%============================================
% New_ROI
%============================================
function IMAGEANLZ = ImAnlz_NewROICreate(IMAGEANLZ)

%---------------------------------------------
% Create
%---------------------------------------------
IMAGEANLZ.GETROIS = 1;
IMAGEANLZ.CURRENTROI = ImageRoiClass(IMAGEANLZ);
IMAGEANLZ.TEMPROI = ImageRoiClass(IMAGEANLZ);

IMAGEANLZ.TEMPROI.AddNewRegion(IMAGEANLZ.(IMAGEANLZ.activeroi));
IMAGEANLZ.TEMPROI.InitializeRegion;

IMAGEANLZ.buttonfunction = 'CreateROI';
IMAGEANLZ.movefunction = '';
IMAGEANLZ.pointer = IMAGEANLZ.TEMPROI.GetPointer;

IMAGEANLZ.FIGOBJS.MakeCurrentVisible;

Status(1).state = 'busy';
Status(1).string = 'New ROI Active';       
Status(2).state = 'busy';  
Status(2).string = IMAGEANLZ.TEMPROI.GetStatus;   
Status(3).state = 'info';  
Status(3).string = IMAGEANLZ.TEMPROI.GetInfo;        
IMAGEANLZ.STATUS.SetStatus(Status)




