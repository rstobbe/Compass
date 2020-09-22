%===================================================
% Zoom_In3
%===================================================
function Zoom_In3(AX,tab,axnum)

global IMAGEANLZ

SCALE = IMAGEANLZ.(tab)(axnum).SCALE;
pixdim = IMAGEANLZ.(tab)(axnum).GetPixelDimensions;
imsize = IMAGEANLZ.(tab)(axnum).GetImageSize;
pixratio = pixdim(2)/pixdim(1);
imratio = pixratio*imsize(1)/imsize(2); 
aspectratio = IMAGEANLZ.(tab)(axnum).GetFigureAspectRatio;

if strcmp(IMAGEANLZ.(tab)(axnum).ORIENT,'Sagittal')
    imratio = 1/imratio;
end

zmrate = 0.1;

Xdim = SCALE.xmax-SCALE.xmin;
Ydim = SCALE.ymax-SCALE.ymin;
scaleratio = pixratio*Xdim/Ydim;

if imratio < aspectratio
    if scaleratio > aspectratio
        ratio = 1;
    else
        axesratio = 1/aspectratio;
        ratio = (imratio*axesratio)^2.5;
    end
else
    if scaleratio > aspectratio
        axesratio = 1/aspectratio;
        ratio = (imratio*axesratio)^2.5;
        if ratio > 13
            ratio = 13;
        end
        zmrate = zmrate/3;
    else
        ratio = 1;
    end
end
if ratio < 1
    xzmrate = zmrate*ratio;
    yzmrate = zmrate;
else
    yzmrate = zmrate;
    xzmrate = zmrate*ratio;
end

pt = AX.CurrentPoint;
X = pt(1,1);
Y = pt(1,2);

%------------------------------------------------
% Current Dimensions
%------------------------------------------------
Xdim = SCALE.xmax-SCALE.xmin;
Ydim = SCALE.ymax-SCALE.ymin;
SCALE.xmin = (xzmrate)*X + (1-xzmrate)*SCALE.xmin;
SCALE.xmax = SCALE.xmin + (1-xzmrate)*Xdim;
SCALE.ymin = (yzmrate)*Y + (1-yzmrate)*SCALE.ymin;
SCALE.ymax = SCALE.ymin + (1-yzmrate)*Ydim;

if IMAGEANLZ.(tab)(axnum).ZOOMTIE == 1
    for n = 1:IMAGEANLZ.(tab)(axnum).axeslen;
        IMAGEANLZ.(tab)(n).RecordScaleFactors(SCALE); 
        IMAGEANLZ.(tab)(n).SetScale; 
    end
else
    IMAGEANLZ.(tab)(axnum).RecordScaleFactors(SCALE);
    IMAGEANLZ.(tab)(axnum).SetScale; 
end
drawnow;
