%============================================
% 
%============================================
function ImAnlz_OverlaySaveContrast(IMAGEANLZ,overlaynum)

if overlaynum > length(IMAGEANLZ.OMaxContrastMax)
    return
end
n = overlaynum;

if strcmp(IMAGEANLZ.OImType,'abs')
    IMAGEANLZ.OContrastSettings{n}.MaxAbsMaxCurrent = IMAGEANLZ.OMaxContrastMax(n);
    IMAGEANLZ.OContrastSettings{n}.AbsMax = IMAGEANLZ.OMaxContrastCurrent(n);
    IMAGEANLZ.OContrastSettings{n}.MinAbsMinCurrent = IMAGEANLZ.OMinContrastMin(n);
    IMAGEANLZ.OContrastSettings{n}.AbsMin = IMAGEANLZ.OMinContrastCurrent(n);
elseif strcmp(IMAGEANLZ.OImType,'real')
    IMAGEANLZ.OContrastSettings{n}.MaxRealMaxCurrent = IMAGEANLZ.OMaxContrastMax(n);
    IMAGEANLZ.OContrastSettings{n}.RealMax = IMAGEANLZ.OMaxContrastCurrent(n);
    IMAGEANLZ.OContrastSettings{n}.MinRealMinCurrent = IMAGEANLZ.OMinContrastMin(n);
    IMAGEANLZ.OContrastSettings{n}.RealMin = IMAGEANLZ.OMinContrastCurrent(n);
elseif strcmp(IMAGEANLZ.OImType,'imag')
    IMAGEANLZ.OContrastSettings{n}.MaxImagMaxCurrent = IMAGEANLZ.OMaxContrastMax(n);
    IMAGEANLZ.OContrastSettings{n}.ImagMax = IMAGEANLZ.OMaxContrastCurrent(n);
    IMAGEANLZ.OContrastSettings{n}.MinImagMinCurrent = IMAGEANLZ.OMinContrastMin(n);
    IMAGEANLZ.OContrastSettings{n}.ImagMin = IMAGEANLZ.OMinContrastCurrent(n);
elseif strcmp(IMAGEANLZ.OImType,'phase')
    IMAGEANLZ.OContrastSettings{n}.MaxPhaseMaxCurrent = IMAGEANLZ.OMaxContrastMax(n);
    IMAGEANLZ.OContrastSettings{n}.PhaseMax = IMAGEANLZ.OMaxContrastCurrent(n);
    IMAGEANLZ.OContrastSettings{n}.MinPhaseMinCurrent = IMAGEANLZ.OMinContrastMin(n);
    IMAGEANLZ.OContrastSettings{n}.PhaseMin = IMAGEANLZ.OMinContrastCurrent(n);
elseif strcmp(IMAGEANLZ.OImType,'map')
    IMAGEANLZ.OContrastSettings{n}.MaxMapMaxCurrent = IMAGEANLZ.OMaxContrastMax(n);
    IMAGEANLZ.OContrastSettings{n}.MapMax = IMAGEANLZ.OMaxContrastCurrent(n);
    IMAGEANLZ.OContrastSettings{n}.MinMapMinCurrent = IMAGEANLZ.OMinContrastMin(n);
    IMAGEANLZ.OContrastSettings{n}.MapMin = IMAGEANLZ.OMinContrastCurrent(n);
end
    