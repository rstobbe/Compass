%============================================
% 
%============================================
function ImAnlz_UpdateContrastTypeChange(IMAGEANLZ)

ContrastSettings = IMAGEANLZ.ContrastSettings;
if strcmp(IMAGEANLZ.ImType,'abs')
    IMAGEANLZ.MaxContrastMax = ContrastSettings.MaxAbsMaxCurrent;
    IMAGEANLZ.MaxContrastCurrent = ContrastSettings.AbsMax;
    IMAGEANLZ.MinContrastMin = ContrastSettings.MinAbsMinCurrent;
    IMAGEANLZ.MinContrastCurrent = ContrastSettings.AbsMin;
elseif strcmp(IMAGEANLZ.ImType,'real')
    IMAGEANLZ.MaxContrastMax = ContrastSettings.MaxRealMaxCurrent;
    IMAGEANLZ.MaxContrastCurrent = ContrastSettings.RealMax;
    IMAGEANLZ.MinContrastMin = ContrastSettings.MinRealMinCurrent;
    IMAGEANLZ.MinContrastCurrent = ContrastSettings.RealMin;
elseif strcmp(IMAGEANLZ.ImType,'imag')
    IMAGEANLZ.MaxContrastMax = ContrastSettings.MaxImagMaxCurrent;
    IMAGEANLZ.MaxContrastCurrent = ContrastSettings.ImagMax;
    IMAGEANLZ.MinContrastMin = ContrastSettings.MinImagMinCurrent;
    IMAGEANLZ.MinContrastCurrent = ContrastSettings.ImagMin;
elseif strcmp(IMAGEANLZ.ImType,'phase')
    IMAGEANLZ.MaxContrastMax = ContrastSettings.MaxPhaseMaxCurrent;
    IMAGEANLZ.MaxContrastCurrent = ContrastSettings.PhaseMax;
    IMAGEANLZ.MinContrastMin = ContrastSettings.MinPhaseMinCurrent;
    IMAGEANLZ.MinContrastCurrent = ContrastSettings.PhaseMin;
elseif strcmp(IMAGEANLZ.ImType,'map')
    IMAGEANLZ.MaxContrastMax = ContrastSettings.MaxMapMaxCurrent;
    IMAGEANLZ.MaxContrastCurrent = ContrastSettings.MapMax;
    IMAGEANLZ.MinContrastMin = ContrastSettings.MinMapMinCurrent;
    IMAGEANLZ.MinContrastCurrent = ContrastSettings.MapMin;
end

IMAGEANLZ.MaxContrastMax = gather(IMAGEANLZ.MaxContrastMax);
IMAGEANLZ.MaxContrastCurrent = gather(IMAGEANLZ.MaxContrastCurrent);
IMAGEANLZ.MinContrastMin = gather(IMAGEANLZ.MinContrastMin);
IMAGEANLZ.MinContrastCurrent = gather(IMAGEANLZ.MinContrastCurrent);
    