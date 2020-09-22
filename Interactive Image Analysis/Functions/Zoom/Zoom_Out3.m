%===================================================
% Zoom_Out
%===================================================
function Zoom_Out3(AX,tab,axnum)

global IMAGEANLZ

SCALE = IMAGEANLZ.(tab)(axnum).SCALE;
imsize = IMAGEANLZ.(tab)(axnum).GetImageSize;

zmrate = 0.1;

pt = AX.CurrentPoint;
X = pt(1,1);
Y = pt(1,2);

%------------------------------------------------
% Current Dimesions
%------------------------------------------------
Xdim = SCALE.xmax-SCALE.xmin;
Ydim = SCALE.ymax-SCALE.ymin;
if Xdim*(1+zmrate) >= imsize(2) || Ydim*(1+zmrate) >= imsize(1)
    SCALE.xmin = 0.5;
    SCALE.ymin = 0.5;
    SCALE.xmax = imsize(2)+0.5;
    SCALE.ymax = imsize(1)+0.5; 
else
    SCALE.xmin = -(zmrate)*X + (1+zmrate)*SCALE.xmin;
    SCALE.xmax = SCALE.xmin + (1+zmrate)*Xdim;
    SCALE.ymin = -(zmrate)*Y + (1+zmrate)*SCALE.ymin;
    SCALE.ymax = SCALE.ymin + (1+zmrate)*Ydim;
end

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
