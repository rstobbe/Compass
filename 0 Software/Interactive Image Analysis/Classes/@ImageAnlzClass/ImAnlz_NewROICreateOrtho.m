%============================================
% New_ROI
%============================================
function IMAGEANLZ = ImAnlz_NewROICreateOrtho(IMAGEANLZ,ROITOOL)

%---------------------------------------------
% Create
%---------------------------------------------
IMAGEANLZ.GETROIS = 1;
IMAGEANLZ.CURRENTROI = ImageRoiClass(IMAGEANLZ);
IMAGEANLZ.TEMPROI = ImageRoiClass(IMAGEANLZ);

IMAGEANLZ.buttonfunction = 'CreateROI';
IMAGEANLZ.movefunction = '';

IMAGEANLZ.TEMPROI.AddNewRegion(ROITOOL);
IMAGEANLZ.TEMPROI.InitializeRegion;
IMAGEANLZ.pointer = IMAGEANLZ.TEMPROI.GetPointer;

if IMAGEANLZ.GETROIS
    for n = 1:length(IMAGEANLZ.ortholine)
        if isgraphics(IMAGEANLZ.ortholine(n))
            IMAGEANLZ.ortholine(n).PickableParts = 'none';
        end
    end
end

Status(1).state = 'busy';
Status(1).string = 'ROI Active';       
Status(2).state = 'busy';  
Status(2).string = IMAGEANLZ.TEMPROI.GetStatus;   
Status(3).state = 'info';  
Status(3).string = IMAGEANLZ.TEMPROI.GetInfo;        
IMAGEANLZ.STATUS.SetStatus(Status)




