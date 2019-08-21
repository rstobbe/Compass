%===================================================
% Zoom_In3
%===================================================
function Zoom_InOrtho(tab,axnum0)

global IMAGEANLZ

curmat = IMAGEANLZ.(tab)(axnum0).curmat;
zmrate = 0.1;

for axnum = 1:3

    SCALE = IMAGEANLZ.(tab)(axnum).SCALE;
    imsize = IMAGEANLZ.(tab)(axnum).GetImageSize;
    pixdim = IMAGEANLZ.(tab)(axnum).GetPixelDimensions;
    pixratio = pixdim(2)/pixdim(1);
    aspectratio = IMAGEANLZ.(tab)(axnum).GetFigureAspectRatio;
    imratio = pixratio*imsize(2)/imsize(1); 
    
    if strcmp(IMAGEANLZ.(tab)(axnum).ORIENT,'Axial')
        X = curmat(1);
        Y = curmat(2);
        %DynamicOrthoReslice(tab,axnum0,X,Y);
    elseif strcmp(IMAGEANLZ.(tab)(axnum).ORIENT,'Sagittal')
        X = curmat(2);
        Y = imsize(1)-curmat(3);  
    elseif strcmp(IMAGEANLZ.(tab)(axnum).ORIENT,'Coronal')
        X = curmat(1); 
        Y = imsize(1)-curmat(3);
    end
    
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

    Xdim = SCALE.xmax-SCALE.xmin;
    Ydim = SCALE.ymax-SCALE.ymin;
    SCALE.xmin = (xzmrate)*X + (1-xzmrate)*SCALE.xmin;
    SCALE.xmax = SCALE.xmin + (1-xzmrate)*Xdim;
    SCALE.ymin = (yzmrate)*Y + (1-yzmrate)*SCALE.ymin;
    SCALE.ymax = SCALE.ymin + (1-yzmrate)*Ydim;

    IMAGEANLZ.(tab)(axnum).RecordScaleFactors(SCALE); 
    IMAGEANLZ.(tab)(axnum).SetScale; 
end
