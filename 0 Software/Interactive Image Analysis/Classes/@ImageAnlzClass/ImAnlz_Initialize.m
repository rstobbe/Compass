%============================================
% New_ROI
%============================================
function IMAGEANLZ = ImAnlz_Initialize(IMAGEANLZ,tab,axnum)

%---------------------------------------------
% Basic
%---------------------------------------------
IMAGEANLZ.tab = tab;
IMAGEANLZ.axnum = axnum;
if strcmp(tab,'IM')
    IMAGEANLZ.axeslen = 10;
    IMAGEANLZ.presentation = 'Standard';
elseif strcmp(tab,'IM2')
    IMAGEANLZ.axeslen = 2;
    IMAGEANLZ.presentation = 'Standard';
elseif strcmp(tab,'IM3')
    IMAGEANLZ.axeslen = 3;
    IMAGEANLZ.presentation = 'Ortho';
elseif strcmp(tab,'IM4')
    IMAGEANLZ.axeslen = 4;
    IMAGEANLZ.presentation = 'Standard';
end
IMAGEANLZ.highlight = 0;
IMAGEANLZ.totgblnum = [];
IMAGEANLZ.axisactive = 0;
IMAGEANLZ.shaderoi = 0;
IMAGEANLZ.shaderoivalue = 0;
IMAGEANLZ.shaderoiintensities = [0.04 0.08 0.12];
IMAGEANLZ.linesroi = 0;
IMAGEANLZ.redrawroi = 0;
IMAGEANLZ.autoupdateroi = 0;
IMAGEANLZ.drawroionall = 0;
IMAGEANLZ.temproiclr = [];
IMAGEANLZ.roievent = 'Add';

IMAGEANLZ.imslice = [];
IMAGEANLZ.imvol = [];
IMAGEANLZ.curmat = [1 1 1];
IMAGEANLZ.tinymove = 0;

%---------------------------------------------
% 
%---------------------------------------------
global COMPASSINFO
%-- load
IMAGEANLZ.IMPATH = COMPASSINFO.USERGBL.experimentsloc;
IMAGEANLZ.IMFILETYPE = 'Mat';
IMAGEANLZ.ROIPATH = COMPASSINFO.USERGBL.experimentsloc;
%-- mouse functions
IMAGEANLZ.buttonfunction = '';
IMAGEANLZ.movefunction = '';
%-- contrast
IMAGEANLZ.IMTYPE = 'abs';
IMAGEANLZ.RELCONTRAST = [];                               
IMAGEANLZ.MAXCONTRAST = []; 
IMAGEANLZ.MaxImVal = [];
IMAGEANLZ.MinImVal = [];
%-- orient
IMAGEANLZ.ORIENT = 'Axial';
%-- navigate
IMAGEANLZ.pointer = 'arrow';
IMAGEANLZ.SLICE = 1;
IMAGEANLZ.DIM4 = 1;
IMAGEANLZ.DIM5 = 1;
IMAGEANLZ.DIM6 = 1;
%-- zoom
IMAGEANLZ.SCALE = [];  
%-- drawing
IMAGEANLZ.mark = gobjects(0); 
IMAGEANLZ.ortholine = gobjects(0); 
IMAGEANLZ.showortholine = 0;
%-- rois
IMAGEANLZ.GETROIS = 0;                            
IMAGEANLZ.ROISOFINTEREST = zeros(1,35);                        
IMAGEANLZ.SAVEDROISFLAG = 0;
IMAGEANLZ.COLORORDER = {[0 1 1],[0.1 1 0.5],[0.5 0.4 0.2],[1 1 0.5],[1 0.5 0.1],[1 0.2 1],[0.3 0.3 1] ...
                   [0.2 1 1],[0.2 1 0.6],[0.5 0.5 0.3],[1 1 0.7],[1 0.7 0.1],[1 0.4 1],[0.4 0.4 1] ...
                   [0 0.9 0.9],[0.1 0.8 0.5],[0.4 0.3 0.2],[0.9 0.9 0.5],[0.9 0.4 0.1],[0.9 0.2 0.9],[0.3 0.3 0.8] ...
                   [0 1 1],[0.1 1 0.5],[0.5 0.4 0.2],[1 1 0.5],[1 0.5 0.1],[1 0.2 1],[0.3 0.3 1] ...
                   [0.2 1 1],[0.2 1 0.6],[0.5 0.5 0.3],[1 1 0.7],[1 0.7 0.1],[1 0.4 1],[0.4 0.4 1]};         
%-- line
IMAGEANLZ.GETLINE = 0;
IMAGEANLZ.LineToolActive = 0;
%-- tieing
IMAGEANLZ.ALLTIE = 0;
IMAGEANLZ.DATVALTIE = 0;
IMAGEANLZ.CURSORTIE = 0;
IMAGEANLZ.SLCTIE = 0;
IMAGEANLZ.DIMSTIE = 0;
IMAGEANLZ.ZOOMTIE = 0;
IMAGEANLZ.ROITIE = 0;
%-- holding
IMAGEANLZ.SLCHOLD = 0;
IMAGEANLZ.DIMSHOLD = 0;
IMAGEANLZ.ZOOMHOLD = 0;
IMAGEANLZ.contrasthold = 0;

%---------------------------------------------
% ROI Drawing Class Setup
%---------------------------------------------
IMAGEANLZ.ROIFREEHAND = RoiFreeHandClass;
IMAGEANLZ.ROISEED = RoiSeedClass;
IMAGEANLZ.ROISPHERE = RoiSphereClass;
IMAGEANLZ.ROICIRCLE = RoiCircleClass;
IMAGEANLZ.ROITUBE = RoiTubeClass;
IMAGEANLZ.activeroi = 'ROIFREEHAND';
delete(IMAGEANLZ.roipanelobs)
IMAGEANLZ.(IMAGEANLZ.activeroi).Setup(IMAGEANLZ);
IMAGEANLZ.roipanelobs = IMAGEANLZ.(IMAGEANLZ.activeroi).panelobs;

%---------------------------------------------
% ROI Holders
%---------------------------------------------
IMAGEANLZ.TEMPROI = ImageRoiClass.empty;
IMAGEANLZ.CURRENTROI = ImageRoiClass.empty;
IMAGEANLZ.REDRAWROI = ImageRoiClass.empty;
IMAGEANLZ.SAVEDROIS = ImageRoiClass.empty;

%---------------------------------------------
% Line Holders
%---------------------------------------------
IMAGEANLZ.CURRENTLINE = ImageLineClass.empty;
IMAGEANLZ.SAVEDLINES = ImageLineClass.empty;
IMAGEANLZ.GlobalSavedLinesInd = [0 0 0];                  % only 3 saved lines;
IMAGEANLZ.SavedLinesInd = [0 0 0];                  % only 3 saved lines;
IMAGEANLZ.LineClrOrder = 'cgm';

%---------------------------------------------
% Status
%---------------------------------------------
IMAGEANLZ.STATUS = StatusClass(IMAGEANLZ);

