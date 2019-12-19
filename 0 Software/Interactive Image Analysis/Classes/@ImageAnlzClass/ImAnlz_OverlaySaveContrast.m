%============================================
% 
%============================================
function ImAnlz_OverlaySaveContrast(IMAGEANLZ)

if strcmp(IMAGEANLZ.OImType,'abs')
    IMAGEANLZ.OContrastSettings.MaxAbsMaxCurrent = IMAGEANLZ.OMaxContrastMax;
    IMAGEANLZ.OContrastSettings.AbsMax = IMAGEANLZ.OMaxContrastCurrent;
    IMAGEANLZ.OContrastSettings.MinAbsMinCurrent = IMAGEANLZ.OMinContrastMin;
    IMAGEANLZ.OContrastSettings.AbsMin = IMAGEANLZ.OMinContrastCurrent;
elseif strcmp(IMAGEANLZ.OImType,'real')
    IMAGEANLZ.OContrastSettings.MaxRealMaxCurrent = IMAGEANLZ.OMaxContrastMax;
    IMAGEANLZ.OContrastSettings.RealMax = IMAGEANLZ.OMaxContrastCurrent;
    IMAGEANLZ.OContrastSettings.MinRealMinCurrent = IMAGEANLZ.OMinContrastMin;
    IMAGEANLZ.OContrastSettings.RealMin = IMAGEANLZ.OMinContrastCurrent;
elseif strcmp(IMAGEANLZ.OImType,'imag')
    IMAGEANLZ.OContrastSettings.MaxImagMaxCurrent = IMAGEANLZ.OMaxContrastMax;
    IMAGEANLZ.OContrastSettings.ImagMax = IMAGEANLZ.OMaxContrastCurrent;
    IMAGEANLZ.OContrastSettings.MinImagMinCurrent = IMAGEANLZ.OMinContrastMin;
    IMAGEANLZ.OContrastSettings.ImagMin = IMAGEANLZ.OMinContrastCurrent;
elseif strcmp(IMAGEANLZ.OImType,'phase')
    IMAGEANLZ.OContrastSettings.MaxPhaseMaxCurrent = IMAGEANLZ.OMaxContrastMax;
    IMAGEANLZ.OContrastSettings.PhaseMax = IMAGEANLZ.OMaxContrastCurrent;
    IMAGEANLZ.OContrastSettings.MinPhaseMinCurrent = IMAGEANLZ.OMinContrastMin;
    IMAGEANLZ.OContrastSettings.PhaseMin = IMAGEANLZ.OMinContrastCurrent;
elseif strcmp(IMAGEANLZ.OImType,'map')
    IMAGEANLZ.OContrastSettings.MaxMapMaxCurrent = IMAGEANLZ.OMaxContrastMax;
    IMAGEANLZ.OContrastSettings.MapMax = IMAGEANLZ.OMaxContrastCurrent;
    IMAGEANLZ.OContrastSettings.MinMapMinCurrent = IMAGEANLZ.OMinContrastMin;
    IMAGEANLZ.OContrastSettings.MapMin = IMAGEANLZ.OMinContrastCurrent;
end
    