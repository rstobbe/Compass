%==========================================================
% 
%==========================================================
function IMAGEROI = ImRoi_ComputeROI(IMAGEROI,IMAGEANLZ)

ImInfo = IMAGEANLZ.GetImageInfo;

if isprop(IMAGEROI,'drawroiorientarray')
    tempdrawroiorient = 'Axial';
else
    tempdrawroiorient = IMAGEROI.drawroiorient;
end

if IMAGEANLZ.complexaverageroi
    Image = IMAGEANLZ.GetComplexOriented3DImage(tempdrawroiorient);
    vals = Image(logical(IMAGEROI.roimask));
    meanvals = mean(vals,'omitnan');
    stdvals = std(vals,'omitnan');
    meanvals = ImageTypeCreate(IMAGEANLZ,meanvals);
    stdvals = ImageTypeCreate(IMAGEANLZ,stdvals);
else
    Image = IMAGEANLZ.GetOriented3DImage(tempdrawroiorient);
    vals = Image(logical(IMAGEROI.roimask));
    meanvals = mean(vals,'omitnan');
    stdvals = std(vals,'omitnan');
end

if not(isempty(vals))
    IMAGEROI.roimean = meanvals;
    IMAGEROI.roisdv = stdvals;
    IMAGEROI.roivol = length(vals)*ImInfo.vox/1000;
else
    IMAGEROI.roimean = 0;
    IMAGEROI.roisdv = 0;
    IMAGEROI.roivol = 0;
end


