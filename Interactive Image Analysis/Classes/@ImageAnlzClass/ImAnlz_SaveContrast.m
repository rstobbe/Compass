%============================================
% 
%============================================
function ImAnlz_SaveContrast(IMAGEANLZ)

if strcmp(IMAGEANLZ.ImType,'abs')
    IMAGEANLZ.ContrastSettings.MaxAbsMaxCurrent = IMAGEANLZ.MaxContrastMax;
    IMAGEANLZ.ContrastSettings.AbsMax = IMAGEANLZ.MaxContrastCurrent;
    IMAGEANLZ.ContrastSettings.MinAbsMinCurrent = IMAGEANLZ.MinContrastMin;
    IMAGEANLZ.ContrastSettings.AbsMin = IMAGEANLZ.MinContrastCurrent;
elseif strcmp(IMAGEANLZ.ImType,'real')
    IMAGEANLZ.ContrastSettings.MaxRealMaxCurrent = IMAGEANLZ.MaxContrastMax;
    IMAGEANLZ.ContrastSettings.RealMax = IMAGEANLZ.MaxContrastCurrent;
    IMAGEANLZ.ContrastSettings.MinRealMinCurrent = IMAGEANLZ.MinContrastMin;
    IMAGEANLZ.ContrastSettings.RealMin = IMAGEANLZ.MinContrastCurrent;
elseif strcmp(IMAGEANLZ.ImType,'imag')
    IMAGEANLZ.ContrastSettings.MaxImagMaxCurrent = IMAGEANLZ.MaxContrastMax;
    IMAGEANLZ.ContrastSettings.ImagMax = IMAGEANLZ.MaxContrastCurrent;
    IMAGEANLZ.ContrastSettings.MinImagMinCurrent = IMAGEANLZ.MinContrastMin;
    IMAGEANLZ.ContrastSettings.ImagMin = IMAGEANLZ.MinContrastCurrent;
elseif strcmp(IMAGEANLZ.ImType,'phase')
    IMAGEANLZ.ContrastSettings.MaxPhaseMaxCurrent = IMAGEANLZ.MaxContrastMax;
    IMAGEANLZ.ContrastSettings.PhaseMax = IMAGEANLZ.MaxContrastCurrent;
    IMAGEANLZ.ContrastSettings.MinPhaseMinCurrent = IMAGEANLZ.MinContrastMin;
    IMAGEANLZ.ContrastSettings.PhaseMin = IMAGEANLZ.MinContrastCurrent;
elseif strcmp(IMAGEANLZ.ImType,'map')
    IMAGEANLZ.ContrastSettings.MaxMapMaxCurrent = IMAGEANLZ.MaxContrastMax;
    IMAGEANLZ.ContrastSettings.MapMax = IMAGEANLZ.MaxContrastCurrent;
    IMAGEANLZ.ContrastSettings.MinMapMinCurrent = IMAGEANLZ.MinContrastMin;
    IMAGEANLZ.ContrastSettings.MapMin = IMAGEANLZ.MinContrastCurrent;
end
    