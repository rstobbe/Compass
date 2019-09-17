%============================================
% 
%============================================
function ImAnlz_InitializeContrast(IMAGEANLZ)

Image = IMAGEANLZ.GetCurrent3DImageComplex;

if isreal(Image)
    MaxVal = max(Image(:));
    MinVal = min(Image(:));
else
    MaxVal = max(abs(Image(:)));
    MinVal = -max(abs(Image(:)));
end

TempImage = abs(Image);
TempImage = TempImage(TempImage ~= 0);
Median = median(TempImage(:));
if MaxVal > 50*Median
    answer = questdlg('Intensity spikes in image. Set full contrast?','Contrast','No');
    if not(strcmp(answer,'Yes'))
        MaxVal = Median*10;
        MaxVal = round(MaxVal,2,'significant');
    end
end

IMAGEANLZ.ContrastSettings.MaxAbsMaxFromImage = MaxVal;
IMAGEANLZ.ContrastSettings.MinAbsMinFromImage = 0;
IMAGEANLZ.ContrastSettings.MaxRealMaxFromImage = MaxVal;
IMAGEANLZ.ContrastSettings.MinRealMinFromImage = -MaxVal;
IMAGEANLZ.ContrastSettings.MaxImagMaxFromImage = MaxVal;
IMAGEANLZ.ContrastSettings.MinImagMinFromImage = -MaxVal;
IMAGEANLZ.ContrastSettings.MaxPhaseMaxFromImage = pi;
IMAGEANLZ.ContrastSettings.MinPhaseMinFromImage = -pi;
IMAGEANLZ.ContrastSettings.MaxMapMaxFromImage = MaxVal;
IMAGEANLZ.ContrastSettings.MinMapMinFromImage = MinVal;

IMAGEANLZ.ContrastSettings.MaxAbsMaxCurrent = MaxVal;
IMAGEANLZ.ContrastSettings.MinAbsMinCurrent = 0;
IMAGEANLZ.ContrastSettings.MaxRealMaxCurrent = MaxVal;
IMAGEANLZ.ContrastSettings.MinRealMinCurrent = -MaxVal;
IMAGEANLZ.ContrastSettings.MaxImagMaxCurrent = MaxVal;
IMAGEANLZ.ContrastSettings.MinImagMinCurrent = -MaxVal;
IMAGEANLZ.ContrastSettings.MaxPhaseMaxCurrent = pi;
IMAGEANLZ.ContrastSettings.MinPhaseMinCurrent = -pi;
IMAGEANLZ.ContrastSettings.MaxMapMaxCurrent = MaxVal;
IMAGEANLZ.ContrastSettings.MinMapMinCurrent = MinVal;

IMAGEANLZ.ContrastSettings.AbsMax = MaxVal;
IMAGEANLZ.ContrastSettings.AbsMin = 0;
IMAGEANLZ.ContrastSettings.RealMax = MaxVal;
IMAGEANLZ.ContrastSettings.RealMin = -MaxVal;
IMAGEANLZ.ContrastSettings.ImagMax = MaxVal;
IMAGEANLZ.ContrastSettings.ImagMin = -MaxVal;
IMAGEANLZ.ContrastSettings.PhaseMax = pi;
IMAGEANLZ.ContrastSettings.PhaseMin = -pi;
IMAGEANLZ.ContrastSettings.MapMax = MaxVal;
IMAGEANLZ.ContrastSettings.MapMin = MinVal;



    