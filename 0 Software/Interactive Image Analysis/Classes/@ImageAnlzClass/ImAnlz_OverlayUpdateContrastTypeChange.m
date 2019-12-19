%============================================
% 
%============================================
function ImAnlz_OverlayUpdateContrastTypeChange(IMAGEANLZ)

OContrastSettings = IMAGEANLZ.OContrastSettings;
if strcmp(IMAGEANLZ.OImType,'abs')
    IMAGEANLZ.OMaxContrastMax = OContrastSettings.MaxAbsMaxCurrent;
    IMAGEANLZ.OMaxContrastCurrent = OContrastSettings.AbsMax;
    IMAGEANLZ.OMinContrastMin = OContrastSettings.MinAbsMinCurrent;
    IMAGEANLZ.OMinContrastCurrent = OContrastSettings.AbsMin;
elseif strcmp(IMAGEANLZ.OImType,'real')
    IMAGEANLZ.OMaxContrastMax = OContrastSettings.MaxRealMaxCurrent;
    IMAGEANLZ.OMaxContrastCurrent = OContrastSettings.RealMax;
    IMAGEANLZ.OMinContrastMin = OContrastSettings.MinRealMinCurrent;
    IMAGEANLZ.OMinContrastCurrent = OContrastSettings.RealMin;
elseif strcmp(IMAGEANLZ.OImType,'imag')
    IMAGEANLZ.OMaxContrastMax = OContrastSettings.MaxImagMaxCurrent;
    IMAGEANLZ.OMaxContrastCurrent = OContrastSettings.ImagMax;
    IMAGEANLZ.OMinContrastMin = OContrastSettings.MinImagMinCurrent;
    IMAGEANLZ.OMinContrastCurrent = OContrastSettings.ImagMin;
elseif strcmp(IMAGEANLZ.OImType,'phase')
    IMAGEANLZ.OMaxContrastMax = OContrastSettings.MaxPhaseMaxCurrent;
    IMAGEANLZ.OMaxContrastCurrent = OContrastSettings.PhaseMax;
    IMAGEANLZ.OMinContrastMin = OContrastSettings.MinPhaseMinCurrent;
    IMAGEANLZ.OMinContrastCurrent = OContrastSettings.PhaseMin;
elseif strcmp(IMAGEANLZ.OImType,'map')
    IMAGEANLZ.OMaxContrastMax = OContrastSettings.MaxMapMaxCurrent;
    IMAGEANLZ.OMaxContrastCurrent = OContrastSettings.MapMax;
    IMAGEANLZ.OMinContrastMin = OContrastSettings.MinMapMinCurrent;
    IMAGEANLZ.OMinContrastCurrent = OContrastSettings.MapMin;
end
    