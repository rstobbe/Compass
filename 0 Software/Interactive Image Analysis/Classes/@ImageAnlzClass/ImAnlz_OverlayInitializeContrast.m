%============================================
% 
%============================================
function ImAnlz_OverlayInitializeContrast(IMAGEANLZ,overlaynum)

Image = IMAGEANLZ.GetCurrent3DImageComplexOverlay(overlaynum);

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

n = overlaynum;

IMAGEANLZ.OContrastSettings{n}.MaxAbsMaxFromImage = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings{n}.MinAbsMinFromImage = 0;
IMAGEANLZ.OContrastSettings{n}.MaxRealMaxFromImage = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings{n}.MinRealMinFromImage = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings{n}.MaxImagMaxFromImage = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings{n}.MinImagMinFromImage = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings{n}.MaxPhaseMaxFromImage = pi;
IMAGEANLZ.OContrastSettings{n}.MinPhaseMinFromImage = -pi;
IMAGEANLZ.OContrastSettings{n}.MaxMapMaxFromImage = MaxVal;
IMAGEANLZ.OContrastSettings{n}.MinMapMinFromImage = MinVal;

IMAGEANLZ.OContrastSettings{n}.MaxAbsMaxCurrent = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings{n}.MinAbsMinCurrent = 0;
IMAGEANLZ.OContrastSettings{n}.MaxRealMaxCurrent = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings{n}.MinRealMinCurrent = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings{n}.MaxImagMaxCurrent = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings{n}.MinImagMinCurrent = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings{n}.MaxPhaseMaxCurrent = pi;
IMAGEANLZ.OContrastSettings{n}.MinPhaseMinCurrent = -pi;
IMAGEANLZ.OContrastSettings{n}.MaxMapMaxCurrent = MaxVal;
IMAGEANLZ.OContrastSettings{n}.MinMapMinCurrent = MinVal;

IMAGEANLZ.OContrastSettings{n}.AbsMax = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings{n}.AbsMin = 0;
IMAGEANLZ.OContrastSettings{n}.RealMax = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings{n}.RealMin = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings{n}.ImagMax = max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings{n}.ImagMin = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.OContrastSettings{n}.PhaseMax = pi;
IMAGEANLZ.OContrastSettings{n}.PhaseMin = -pi;
IMAGEANLZ.OContrastSettings{n}.MapMax = MaxVal;
IMAGEANLZ.OContrastSettings{n}.MapMin = MinVal;



    