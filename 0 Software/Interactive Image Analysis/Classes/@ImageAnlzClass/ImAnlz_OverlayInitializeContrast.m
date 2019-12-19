%============================================
% 
%============================================
function ImAnlz_OverlayInitializeContrast(IMAGEANLZ)

Image = IMAGEANLZ.GetCurrent3DImageComplexOverlay;

if isreal(Image)
    MaxVal = max(Image(:));
    MinVal = min(Image(:));
else
    MaxVal = max(abs(Image(:)));
    MinVal = -max(abs(Image(:)));
end

% TempImage = abs(Image);
% TempImage = TempImage(TempImage ~= 0);
% Median = median(TempImage(:));
% if MaxVal > 100*Median
%     answer = questdlg('Intensity spikes in image. Set full contrast?','Contrast','No');
%     if not(strcmp(answer,'Yes'))
%         MaxVal = Median*10;
%         MaxVal = round(MaxVal,2,'significant');
%     end
% end

IMAGEANLZ.OContrastSettings.MaxAbsMaxFromImage = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings.MinAbsMinFromImage = 0;
IMAGEANLZ.OContrastSettings.MaxRealMaxFromImage = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings.MinRealMinFromImage = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings.MaxImagMaxFromImage = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings.MinImagMinFromImage = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings.MaxPhaseMaxFromImage = pi;
IMAGEANLZ.OContrastSettings.MinPhaseMinFromImage = -pi;
IMAGEANLZ.OContrastSettings.MaxMapMaxFromImage = MaxVal;
IMAGEANLZ.OContrastSettings.MinMapMinFromImage = MinVal;

IMAGEANLZ.OContrastSettings.MaxAbsMaxCurrent = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings.MinAbsMinCurrent = 0;
IMAGEANLZ.OContrastSettings.MaxRealMaxCurrent = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings.MinRealMinCurrent = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings.MaxImagMaxCurrent = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings.MinImagMinCurrent = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings.MaxPhaseMaxCurrent = pi;
IMAGEANLZ.OContrastSettings.MinPhaseMinCurrent = -pi;
IMAGEANLZ.OContrastSettings.MaxMapMaxCurrent = MaxVal;
IMAGEANLZ.OContrastSettings.MinMapMinCurrent = MinVal;

IMAGEANLZ.OContrastSettings.AbsMax = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings.AbsMin = 0;
IMAGEANLZ.OContrastSettings.RealMax = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings.RealMin = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings.ImagMax = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings.ImagMin = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings.PhaseMax = pi;
IMAGEANLZ.OContrastSettings.PhaseMin = -pi;
IMAGEANLZ.OContrastSettings.MapMax = MaxVal;
IMAGEANLZ.OContrastSettings.MapMin = MinVal;



    