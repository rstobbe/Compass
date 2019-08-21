%============================================
% New_Line
%============================================
function IMAGEANLZ = ImAnlz_NewLineCreateOrtho(IMAGEANLZ)

%---------------------------------------------
% Create
%---------------------------------------------
IMAGEANLZ.GETLINE = 1;
IMAGEANLZ.CURRENTLINE = ImageLineClass(IMAGEANLZ);

IMAGEANLZ.buttonfunction = 'CreateLine';
IMAGEANLZ.movefunction = '';

% IMAGEANLZ.TEMPROI.AddNewRegion(ROITOOL);
% IMAGEANLZ.TEMPROI.InitializeRegion;
IMAGEANLZ.pointer = IMAGEANLZ.CURRENTLINE.GetPointer;

if IMAGEANLZ.GETLINE
    for n = 1:length(IMAGEANLZ.ortholine)
        if isgraphics(IMAGEANLZ.ortholine(n))
            IMAGEANLZ.ortholine(n).PickableParts = 'none';
        end
    end
end

Status(1).state = 'busy';
Status(1).string = 'New Line Active';       
Status(2).state = 'busy';  
Status(2).string = IMAGEANLZ.CURRENTLINE.GetStatus;   
Status(3).state = 'info';  
Status(3).string = IMAGEANLZ.CURRENTLINE.GetInfo;        
IMAGEANLZ.STATUS.SetStatus(Status)

 


