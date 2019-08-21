%===================================================
% Zoom_Out
%===================================================
function Zoom_OutOrtho(tab,axnum0)

global IMAGEANLZ

curmat = IMAGEANLZ.(tab)(axnum0).curmat;

for axnum = 1:3
    if strcmp(IMAGEANLZ.(tab)(axnum).ORIENT,'Axial')
        X = curmat(1);
        Y = curmat(2);
    elseif strcmp(IMAGEANLZ.(tab)(axnum).ORIENT,'Sagittal')
        imsize = IMAGEANLZ.(tab)(axnum).GetImageSize;
        X = curmat(2);
        Y = imsize(1)-curmat(3);   
    elseif strcmp(IMAGEANLZ.(tab)(axnum).ORIENT,'Coronal')
        imsize = IMAGEANLZ.(tab)(axnum).GetImageSize;
        X = curmat(1); 
        Y = imsize(1)-curmat(3); 
    end

    SCALE = IMAGEANLZ.(tab)(axnum).SCALE;
    imsize = IMAGEANLZ.(tab)(axnum).GetImageSize;

    zmrate = 0.1;

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

    IMAGEANLZ.(tab)(axnum).RecordScaleFactors(SCALE); 
    IMAGEANLZ.(tab)(axnum).SetScale; 
end

