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

IMAGEANLZ.ContrastSettings.MaxAbsMaxFromImage = max([MaxVal abs(MinVal)]);
IMAGEANLZ.ContrastSettings.MinAbsMinFromImage = 0;
IMAGEANLZ.ContrastSettings.MaxRealMaxFromImage = max([MaxVal abs(MinVal)]);
IMAGEANLZ.ContrastSettings.MinRealMinFromImage = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.ContrastSettings.MaxImagMaxFromImage = max([MaxVal abs(MinVal)]);
IMAGEANLZ.ContrastSettings.MinImagMinFromImage = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.ContrastSettings.MaxPhaseMaxFromImage = pi;
IMAGEANLZ.ContrastSettings.MinPhaseMinFromImage = -pi;
IMAGEANLZ.ContrastSettings.MaxMapMaxFromImage = MaxVal;
IMAGEANLZ.ContrastSettings.MinMapMinFromImage = MinVal;

IMAGEANLZ.ContrastSettings.MaxAbsMaxCurrent = max([MaxVal abs(MinVal)]);
IMAGEANLZ.ContrastSettings.MinAbsMinCurrent = 0;
IMAGEANLZ.ContrastSettings.MaxRealMaxCurrent = max([MaxVal abs(MinVal)]);
IMAGEANLZ.ContrastSettings.MinRealMinCurrent = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.ContrastSettings.MaxImagMaxCurrent = max([MaxVal abs(MinVal)]);
IMAGEANLZ.ContrastSettings.MinImagMinCurrent = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.ContrastSettings.MaxPhaseMaxCurrent = pi;
IMAGEANLZ.ContrastSettings.MinPhaseMinCurrent = -pi;
IMAGEANLZ.ContrastSettings.MaxMapMaxCurrent = MaxVal;
IMAGEANLZ.ContrastSettings.MinMapMinCurrent = MinVal;

IMAGEANLZ.ContrastSettings.AbsMax = max([MaxVal abs(MinVal)]);
IMAGEANLZ.ContrastSettings.AbsMin = 0;
IMAGEANLZ.ContrastSettings.RealMax = max([MaxVal abs(MinVal)]);
IMAGEANLZ.ContrastSettings.RealMin = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.ContrastSettings.ImagMax = max([MaxVal abs(MinVal)]);
IMAGEANLZ.ContrastSettings.ImagMin = -max([MaxVal abs(MinVal)]);
IMAGEANLZ.ContrastSettings.PhaseMax = pi;
IMAGEANLZ.ContrastSettings.PhaseMin = -pi;
IMAGEANLZ.ContrastSettings.MapMax = MaxVal;
IMAGEANLZ.ContrastSettings.MapMin = MinVal;



    