%============================================
% 
%============================================
function IMAGEANLZ = ImAnlz_DefaultSetup(IMAGEANLZ)

IMAGEANLZ.FIGOBJS.ROICreateSel.Value = IMAGEANLZ.(IMAGEANLZ.activeroi).roicreatesel;

% IMAGEANLZ.DATVALTIE = 1;
% IMAGEANLZ.FIGOBJS.TieDatVals.Value = 1;
% IMAGEANLZ.SLCTIE = 1;
% IMAGEANLZ.FIGOBJS.TieSlice.Value = 1;
% IMAGEANLZ.DIMSTIE = 1;
% IMAGEANLZ.FIGOBJS.TieDims.Value = 1;
% IMAGEANLZ.ZOOMTIE = 1;
% IMAGEANLZ.FIGOBJS.TieZoom.Value = 1;
% IMAGEANLZ.ROITIE = 1;
% IMAGEANLZ.FIGOBJS.TieROIs.Value = 1;


IMAGEANLZ.shaderoi = 0;
IMAGEANLZ.FIGOBJS.ShadeROI.Value = 0;
IMAGEANLZ.autoupdateroi = 1;
IMAGEANLZ.FIGOBJS.AutoUpdateROI.Value = 1;
IMAGEANLZ.linesroi = 1;
IMAGEANLZ.FIGOBJS.LinesROI.Value = 1;
IMAGEANLZ.shaderoivalue = 0.10;
IMAGEANLZ.FIGOBJS.ShadeROIValue.Value = 0.10;

IMAGEANLZ.FIGOBJS.ImAxes.YDir = 'reverse';                              % copy 'image' command
IMAGEANLZ.FIGOBJS.ImAxes.XTick = [];
IMAGEANLZ.FIGOBJS.ImAxes.YTick = [];
IMAGEANLZ.FIGOBJS.ImAxes.ButtonDownFcn = @ButtonPressControl;
IMAGEANLZ.FIGOBJS.ImAxes.PickableParts = 'all';
IMAGEANLZ.FIGOBJS.ImAxes.Interruptible = 'off';
