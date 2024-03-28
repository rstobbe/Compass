%============================================
% 
%============================================
function ImAnlz_InitializeContrast(IMAGEANLZ)

%Image = IMAGEANLZ.GetCurrent3DImageComplex;
global TOTALGBL
Image = TOTALGBL{2,IMAGEANLZ.totgblnum}.Im;

if isreal(Image)
    MaxVal = max(Image(:));
    MinVal = min(Image(:));
else
    %MaxVal = max(abs(Image(:)));           % this gives me a GPU error
    Image = gather(Image);
    MaxVal = max(abs(Image(:)));
    MinVal = -MaxVal;
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

DefaultContrast = IMAGEANLZ.GetDefaultContrast;
IMAGEANLZ.ImType = DefaultContrast.type;
IMAGEANLZ.ContrastSettings.ImType = DefaultContrast.type;
ind = strfind(IMAGEANLZ.FIGOBJS.ImType.String,DefaultContrast.type);
for n = 1:length(ind)
    if not(isempty(ind{n}))
        IMAGEANLZ.FIGOBJS.ImType.Value = n;
        break
    end
end
if strcmp(DefaultContrast.colour,'yes') || strcmp(DefaultContrast.colour,'Yes')
    IMAGEANLZ.ContrastSettings.Colour = 'Yes';
    IMAGEANLZ.FIGOBJS.ImColour.Value = 2;
    colormap(IMAGEANLZ.FIGOBJS.ImAxes,IMAGEANLZ.FIGOBJS.Options.ColorMap);
else
    IMAGEANLZ.ContrastSettings.Colour = 'No';    
    IMAGEANLZ.FIGOBJS.ImColour.Value = 1;
    colormap(IMAGEANLZ.FIGOBJS.ImAxes,IMAGEANLZ.FIGOBJS.Options.GrayMap);
end

if strcmp(DefaultContrast.type,'abs')
    IMAGEANLZ.ContrastSettings.AbsMax = abs(DefaultContrast.dispwid(2));
    IMAGEANLZ.ContrastSettings.AbsMin = abs(DefaultContrast.dispwid(1));
else
    IMAGEANLZ.ContrastSettings.AbsMax = max([MaxVal abs(MinVal)]);
    IMAGEANLZ.ContrastSettings.AbsMin = 0;
end
if strcmp(DefaultContrast.type,'real')
    IMAGEANLZ.ContrastSettings.RealMax = DefaultContrast.dispwid(2);
    IMAGEANLZ.ContrastSettings.RealMin = DefaultContrast.dispwid(1);
else
    IMAGEANLZ.ContrastSettings.RealMax = max([MaxVal abs(MinVal)]);
    IMAGEANLZ.ContrastSettings.RealMin = -max([MaxVal abs(MinVal)]);
end
if strcmp(DefaultContrast.type,'imag')
    IMAGEANLZ.ContrastSettings.ImagMax = DefaultContrast.dispwid(2);
    IMAGEANLZ.ContrastSettings.ImagMin = DefaultContrast.dispwid(1);
else
    IMAGEANLZ.ContrastSettings.ImagMax = max([MaxVal abs(MinVal)]);
    IMAGEANLZ.ContrastSettings.ImagMin = -max([MaxVal abs(MinVal)]);
end
if strcmp(DefaultContrast.type,'phase')
    IMAGEANLZ.ContrastSettings.PhaseMax = DefaultContrast.dispwid(2);
    IMAGEANLZ.ContrastSettings.PhaseMin = DefaultContrast.dispwid(1);
else
    IMAGEANLZ.ContrastSettings.PhaseMax = pi;
    IMAGEANLZ.ContrastSettings.PhaseMin = -pi;
end
if strcmp(DefaultContrast.type,'map')
    IMAGEANLZ.ContrastSettings.MapMax = DefaultContrast.dispwid(2);
    IMAGEANLZ.ContrastSettings.MapMin = DefaultContrast.dispwid(1);
    if IMAGEANLZ.ContrastSettings.MapMin < MinVal
        IMAGEANLZ.ContrastSettings.MinMapMinCurrent = IMAGEANLZ.ContrastSettings.MapMin;
    end
else
    IMAGEANLZ.ContrastSettings.MapMax = MaxVal;
    IMAGEANLZ.ContrastSettings.MapMin = MinVal;
end





    