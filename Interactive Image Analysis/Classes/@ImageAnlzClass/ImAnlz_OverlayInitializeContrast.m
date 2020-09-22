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

DefaultContrast = IMAGEANLZ.GetDefaultContrastOverlay(n);
IMAGEANLZ.OImType{n} = DefaultContrast.type;
IMAGEANLZ.OContrastSettings{n}.Type = DefaultContrast.type;
if strcmp(DefaultContrast.colour,'yes') || strcmp(DefaultContrast.colour,'Yes')
    IMAGEANLZ.OContrastSettings{n}.Colour = 'Yes';
    IMAGEANLZ.FIGOBJS.OverlayColour(n).Value = 2;
    IMAGEANLZ.OverlayColour{n} = 'Yes';
else
    IMAGEANLZ.OContrastSettings{n}.Colour = 'No';
    IMAGEANLZ.FIGOBJS.OverlayColour(n).Value = 1;
    IMAGEANLZ.OverlayColour{n} = 'No';
end

if strcmp(DefaultContrast.type,'abs')
    IMAGEANLZ.OContrastSettings{n}.AbsMax = abs(DefaultContrast.dispwid(2));
    IMAGEANLZ.OContrastSettings{n}.AbsMin = abs(DefaultContrast.dispwid(1));
else
    IMAGEANLZ.OContrastSettings{n}.AbsMax = max([MaxVal abs(MinVal)]);
    IMAGEANLZ.OContrastSettings{n}.AbsMin = 0;
end
if strcmp(DefaultContrast.type,'real')
    IMAGEANLZ.OContrastSettings{n}.RealMax = DefaultContrast.dispwid(2);
    IMAGEANLZ.OContrastSettings{n}.RealMin = DefaultContrast.dispwid(1);
else
    IMAGEANLZ.OContrastSettings{n}.RealMax = max([MaxVal abs(MinVal)]);
    IMAGEANLZ.OContrastSettings{n}.RealMin = -max([MaxVal abs(MinVal)]);
end
if strcmp(DefaultContrast.type,'imag')
    IMAGEANLZ.OContrastSettings{n}.ImagMax = DefaultContrast.dispwid(2);
    IMAGEANLZ.OContrastSettings{n}.ImagMin = DefaultContrast.dispwid(1);
else
    IMAGEANLZ.OContrastSettings{n}.ImagMax = max([MaxVal abs(MinVal)]);
    IMAGEANLZ.OContrastSettings{n}.ImagMin = -max([MaxVal abs(MinVal)]);
end
if strcmp(DefaultContrast.type,'phase')
    IMAGEANLZ.OContrastSettings{n}.PhaseMax = DefaultContrast.dispwid(2);
    IMAGEANLZ.OContrastSettings{n}.PhaseMin = DefaultContrast.dispwid(1);
else
    IMAGEANLZ.OContrastSettings{n}.PhaseMax = max([MaxVal abs(MinVal)]);
    IMAGEANLZ.OContrastSettings{n}.PhaseMin = -max([MaxVal abs(MinVal)]);
end
if strcmp(DefaultContrast.type,'map')
    IMAGEANLZ.OContrastSettings{n}.MapMax = DefaultContrast.dispwid(2);
    IMAGEANLZ.OContrastSettings{n}.MapMin = DefaultContrast.dispwid(1);
    if IMAGEANLZ.OContrastSettings{n}.MapMin < MinVal
        IMAGEANLZ.OContrastSettings{n}.MinMapMinCurrent = IMAGEANLZ.OContrastSettings{n}.MapMin;
    end
else
    IMAGEANLZ.OContrastSettings{n}.MapMax = MaxVal;
    IMAGEANLZ.OContrastSettings{n}.MapMin = MinVal;
end



    