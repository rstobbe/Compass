%============================================
% New_Box
%============================================
function IMAGEANLZ = ImAnlz_NewBoxCreateOrtho(IMAGEANLZ)

%---------------------------------------------
% Create
%---------------------------------------------
IMAGEANLZ.BoxToolActive = 1;
sz = size(IMAGEANLZ.imvol);
IMAGEANLZ.CURRENTBOX = ImageBoxClass(IMAGEANLZ,sz);

IMAGEANLZ.buttonfunction = 'CreateBox';
IMAGEANLZ.movefunction = '';

IMAGEANLZ.pointer = IMAGEANLZ.CURRENTBOX.GetPointer;
set(gcf,'pointer',IMAGEANLZ.pointer);

if IMAGEANLZ.GETBOX
    for n = 1:length(IMAGEANLZ.ortholine)
        if isgraphics(IMAGEANLZ.ortholine(n))
            IMAGEANLZ.ortholine(n).PickableParts = 'none';
        end
    end
end

Status(1).state = 'busy';
Status(1).string = 'Draw Box';       
Status(2).state = 'busy';  
Status(2).string = IMAGEANLZ.CURRENTBOX.GetStatus;   
Status(3).state = 'info';  
Status(3).string = IMAGEANLZ.CURRENTBOX.GetInfo;        
IMAGEANLZ.STATUS.SetStatus(Status)

 


