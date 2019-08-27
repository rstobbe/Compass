%============================================
% 
%============================================
function ImAnlz_UpdateContrastTypeChange(IMAGEANLZ)

if strcmp(IMAGEANLZ.IMTYPE,'abs')
    IMAGEANLZ.MAXCONTRAST = IMAGEANLZ.MaxImVal;
    IMAGEANLZ.RELCONTRAST = [0 1];
    IMAGEANLZ.FIGOBJS.ContrastMax.Min = 0;
    IMAGEANLZ.FIGOBJS.ContrastMin.Min = 0;
    IMAGEANLZ.FIGOBJS.ContrastMax.Value = 1;
    IMAGEANLZ.FIGOBJS.ContrastMin.Value = 0;
    IMAGEANLZ.FIGOBJS.CMaxVal.String = num2str(IMAGEANLZ.MaxImVal,5);
    IMAGEANLZ.FIGOBJS.CMinVal.String = 0;
elseif strcmp(IMAGEANLZ.IMTYPE,'real')
    IMAGEANLZ.MAXCONTRAST = IMAGEANLZ.MaxImVal;
    IMAGEANLZ.RELCONTRAST = [-1 1];
    IMAGEANLZ.FIGOBJS.ContrastMax.Min = -1;
    IMAGEANLZ.FIGOBJS.ContrastMin.Min = -1;
    IMAGEANLZ.FIGOBJS.ContrastMax.Value = 1;
    IMAGEANLZ.FIGOBJS.ContrastMin.Value = -1;
    IMAGEANLZ.FIGOBJS.CMaxVal.String = num2str(IMAGEANLZ.MaxImVal,5);
    IMAGEANLZ.FIGOBJS.CMinVal.String = num2str(-IMAGEANLZ.MaxImVal,5);
elseif strcmp(IMAGEANLZ.IMTYPE,'imag')
    IMAGEANLZ.MAXCONTRAST = IMAGEANLZ.MaxImVal;
    IMAGEANLZ.RELCONTRAST = [-1 1];
    IMAGEANLZ.FIGOBJS.ContrastMax.Min = -1;
    IMAGEANLZ.FIGOBJS.ContrastMin.Min = -1;
    IMAGEANLZ.FIGOBJS.ContrastMax.Value = 1;
    IMAGEANLZ.FIGOBJS.ContrastMin.Value = -1;
    IMAGEANLZ.FIGOBJS.CMaxVal.String = num2str(IMAGEANLZ.MaxImVal,5);
    IMAGEANLZ.FIGOBJS.CMinVal.String = num2str(-IMAGEANLZ.MaxImVal,5);
elseif strcmp(IMAGEANLZ.IMTYPE,'phase')
    IMAGEANLZ.MAXCONTRAST = pi;
    IMAGEANLZ.RELCONTRAST = [-1 1];
    IMAGEANLZ.FIGOBJS.ContrastMax.Min = -1;
    IMAGEANLZ.FIGOBJS.ContrastMin.Min = -1;
    IMAGEANLZ.FIGOBJS.ContrastMax.Value = 1;
    IMAGEANLZ.FIGOBJS.ContrastMin.Value = -1;
    IMAGEANLZ.FIGOBJS.CMaxVal.String = num2str(pi,5);
    IMAGEANLZ.FIGOBJS.CMinVal.String = num2str(-pi,5);
elseif strcmp(IMAGEANLZ.IMTYPE,'map')
    IMAGEANLZ.MAXCONTRAST = IMAGEANLZ.MaxImVal;
    IMAGEANLZ.RELCONTRAST = [IMAGEANLZ.MinImVal/IMAGEANLZ.MaxImVal 1];
    IMAGEANLZ.FIGOBJS.ContrastMax.Min = IMAGEANLZ.MinImVal/IMAGEANLZ.MaxImVal;
    IMAGEANLZ.FIGOBJS.ContrastMin.Min = IMAGEANLZ.MinImVal/IMAGEANLZ.MaxImVal;
    IMAGEANLZ.FIGOBJS.ContrastMax.Value = 1;
    IMAGEANLZ.FIGOBJS.ContrastMin.Value = IMAGEANLZ.MinImVal/IMAGEANLZ.MaxImVal;
    IMAGEANLZ.FIGOBJS.CMaxVal.String = num2str(IMAGEANLZ.MaxImVal,5);
    IMAGEANLZ.FIGOBJS.CMinVal.String = num2str(IMAGEANLZ.MinImVal,5);
end
    