%==========================================================
% 
%==========================================================
function IMAGEANLZ = ImAnlz_SetROITool(IMAGEANLZ,activeroi)

%---------------------------------------------
% Run ROI Setup
%---------------------------------------------
IMAGEANLZ.activeroi = activeroi;
IMAGEANLZ.(activeroi).Setup(IMAGEANLZ);

%---------------------------------------------
% Panel
%---------------------------------------------
IMAGEANLZ.FIGOBJS.ROICreateSel.Value = IMAGEANLZ.(activeroi).roicreatesel;
IMAGEANLZ.roipanelobs = IMAGEANLZ.(activeroi).panelobs;

%---------------------------------------------
% Return if ROI not Active
%---------------------------------------------
if IMAGEANLZ.GETROIS == 0
    return
end

%---------------------------------------------
% Complete
%---------------------------------------------
IMAGEANLZ.TEMPROI = ImageRoiClass(IMAGEANLZ);
IMAGEANLZ.TEMPROI.AddNewRegion(IMAGEANLZ.(IMAGEANLZ.activeroi));
IMAGEANLZ.TEMPROI.InitializeRegion;
IMAGEANLZ.pointer = IMAGEANLZ.TEMPROI.GetPointer;

Status2('busy',IMAGEANLZ.TEMPROI.GetStatus,2);
Status2('info',IMAGEANLZ.TEMPROI.GetInfo,3);  

