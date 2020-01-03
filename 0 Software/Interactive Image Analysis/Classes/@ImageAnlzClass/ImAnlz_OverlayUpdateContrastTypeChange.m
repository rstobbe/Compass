%============================================
% 
%============================================
function ImAnlz_OverlayUpdateContrastTypeChange(IMAGEANLZ,overlaynum)

n = overlaynum;
OContrastSettings = IMAGEANLZ.OContrastSettings{n};
if strcmp(IMAGEANLZ.OImType,'abs')
    IMAGEANLZ.OMaxContrastMax(n) = OContrastSettings.MaxAbsMaxCurrent;
    IMAGEANLZ.OMaxContrastCurrent(n) = OContrastSettings.AbsMax;
    IMAGEANLZ.OMinContrastMin(n) = OContrastSettings.MinAbsMinCurrent;
    IMAGEANLZ.OMinContrastCurrent(n) = OContrastSettings.AbsMin;
elseif strcmp(IMAGEANLZ.OImType,'real')
    IMAGEANLZ.OMaxContrastMax(n) = OContrastSettings.MaxRealMaxCurrent;
    IMAGEANLZ.OMaxContrastCurrent(n) = OContrastSettings.RealMax;
    IMAGEANLZ.OMinContrastMin(n) = OContrastSettings.MinRealMinCurrent;
    IMAGEANLZ.OMinContrastCurrent(n) = OContrastSettings.RealMin;
elseif strcmp(IMAGEANLZ.OImType,'imag')
    IMAGEANLZ.OMaxContrastMax(n) = OContrastSettings.MaxImagMaxCurrent;
    IMAGEANLZ.OMaxContrastCurrent(n) = OContrastSettings.ImagMax;
    IMAGEANLZ.OMinContrastMin(n) = OContrastSettings.MinImagMinCurrent;
    IMAGEANLZ.OMinContrastCurrent(n) = OContrastSettings.ImagMin;
elseif strcmp(IMAGEANLZ.OImType,'phase')
    IMAGEANLZ.OMaxContrastMax(n) = OContrastSettings.MaxPhaseMaxCurrent;
    IMAGEANLZ.OMaxContrastCurrent(n) = OContrastSettings.PhaseMax;
    IMAGEANLZ.OMinContrastMin(n) = OContrastSettings.MinPhaseMinCurrent;
    IMAGEANLZ.OMinContrastCurrent(n) = OContrastSettings.PhaseMin;
elseif strcmp(IMAGEANLZ.OImType,'map')
    IMAGEANLZ.OMaxContrastMax(n) = OContrastSettings.MaxMapMaxCurrent;
    IMAGEANLZ.OMaxContrastCurrent(n) = OContrastSettings.MapMax;
    IMAGEANLZ.OMinContrastMin(n) = OContrastSettings.MinMapMinCurrent;
    IMAGEANLZ.OMinContrastCurrent(n) = OContrastSettings.MapMin;
end
    