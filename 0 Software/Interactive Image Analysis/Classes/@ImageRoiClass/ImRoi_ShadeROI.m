%==========================================================
% 
%==========================================================
function IMAGEROI = ImRoi_ShadeROI(IMAGEROI,IMAGEANLZ,axhand,clr,intensity)

if isempty(IMAGEROI.roimask)
    IMAGEROI.CreateBaseROIMask;
end

if isempty(axhand)
    axhand = IMAGEANLZ.GetAxisHandle;
end

if ischar(clr)
    if strcmp(clr,'r')
        clr = [1 0 0];
    end
end

if isprop(IMAGEROI,'drawroiorientarray')
    if isempty(IMAGEROI.drawroiorientarray)
        tempdrawroiorient = IMAGEROI.drawroiorient;
    else
        tempdrawroiorient = 'Axial';
    end
else
    tempdrawroiorient = IMAGEROI.drawroiorient;
end

if strcmp(tempdrawroiorient,'Axial')
    if strcmp(IMAGEANLZ.ORIENT,'Axial')
        roimask = IMAGEROI.roimask;
    elseif strcmp(IMAGEANLZ.ORIENT,'Sagittal')
        roimask = squeeze(permute(IMAGEROI.roimask,[3 1 2]));
        roimask = flip(roimask,1);
    elseif strcmp(IMAGEANLZ.ORIENT,'Coronal')
        roimask = squeeze(permute(IMAGEROI.roimask,[3 2 1]));
        roimask = flip(roimask,1);
    end
elseif strcmp(tempdrawroiorient,'Sagittal')
    if strcmp(IMAGEANLZ.ORIENT,'Axial')
        roimask = squeeze(permute(IMAGEROI.roimask,[2 3 1]));
        roimask = flip(roimask,3);        
    elseif strcmp(IMAGEANLZ.ORIENT,'Sagittal')
        roimask = IMAGEROI.roimask;
    elseif strcmp(IMAGEANLZ.ORIENT,'Coronal')
        roimask = squeeze(permute(IMAGEROI.roimask,[1 3 2]));
    end
elseif strcmp(tempdrawroiorient,'Coronal')
    if strcmp(IMAGEANLZ.ORIENT,'Axial')
        roimask = squeeze(permute(IMAGEROI.roimask,[3 2 1]));
        roimask = flip(roimask,3);        
    elseif strcmp(IMAGEANLZ.ORIENT,'Sagittal')
        roimask = squeeze(permute(IMAGEROI.roimask,[1 3 2]));
    elseif strcmp(IMAGEANLZ.ORIENT,'Coronal')
        roimask = IMAGEROI.roimask;
    end
end


roimaskslice = squeeze(roimask(:,:,IMAGEANLZ.SLICE));
roimaskshade = zeros([size(roimaskslice),3]);
roimaskshade(:,:,1) = clr(1)*roimaskslice;
roimaskshade(:,:,2) = clr(2)*roimaskslice;
roimaskshade(:,:,3) = clr(3)*roimaskslice;

if not(isempty(IMAGEROI.shadehandle))
    delete(IMAGEROI.shadehandle);
end
IMAGEANLZ.FIGOBJS.ImAxes.NextPlot = 'add';
IMAGEROI.shadehandle = image(roimaskshade,'Parent',axhand);                 
IMAGEROI.shadehandle.BusyAction = 'cancel';
IMAGEROI.shadehandle.Interruptible = 'off';
IMAGEROI.shadehandle.CDataMapping = 'scaled';
IMAGEROI.shadehandle.PickableParts = 'none';
IMAGEROI.shadehandle.HitTest = 'off';
%alphadata = 0.125*ones(size(roimaskslice));
alphadata = ones(size(roimaskslice));
alphadata(roimaskslice==0) = 0;
IMAGEROI.alphadata = alphadata;
IMAGEROI.shadehandle.AlphaData = intensity*alphadata;
drawnow;
IMAGEANLZ.FIGOBJS.ImAxes.NextPlot = 'replacechildren';

