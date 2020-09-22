%============================================
% 
%============================================
function IMAGEANLZ = ImAnlz_ResetScale(IMAGEANLZ)

global TOTALGBL

SCALE = TOTALGBL{2,IMAGEANLZ.totgblnum}.IMDISP.SCALE;
if strcmp(IMAGEANLZ.ORIENT,'Axial')
    IMAGEANLZ.SCALE.xmin = SCALE.xmin;
    IMAGEANLZ.SCALE.xmax = SCALE.xmax;
    IMAGEANLZ.SCALE.ymin = SCALE.ymin;
    IMAGEANLZ.SCALE.ymax = SCALE.ymax;
elseif strcmp(IMAGEANLZ.ORIENT,'Sagittal')
    IMAGEANLZ.SCALE.xmin = SCALE.ymin;
    IMAGEANLZ.SCALE.xmax = SCALE.ymax;
    IMAGEANLZ.SCALE.ymin = SCALE.zmin;
    IMAGEANLZ.SCALE.ymax = SCALE.zmax;
elseif strcmp(IMAGEANLZ.ORIENT,'Coronal')
    IMAGEANLZ.SCALE.xmin = SCALE.xmin;
    IMAGEANLZ.SCALE.xmax = SCALE.xmax;
    IMAGEANLZ.SCALE.ymin = SCALE.zmin;
    IMAGEANLZ.SCALE.ymax = SCALE.zmax;
end


