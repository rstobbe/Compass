%=========================================================
% (v1b) 
%   - additional info for ROI drawing
%=========================================================

function [MCHRS,err] = DefaultMontageChars_v1b(INPUT)

err.flag = 0;
err.msg = '';
MCHRS = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
Image = INPUT.Image;
if isfield(INPUT,'MSTRCT')
    MSTRCT = INPUT.MSTRCT;
else
    MSTRCT.ImInfo.pixdim = [1 1 1 1 1 1];
end
if isfield(INPUT,'numberslices')
    numberslices = INPUT.numberslices;
else
    numberslices = [];
end
if isfield(INPUT,'start')
    start = INPUT.start;
    stop = INPUT.stop; 
    step = INPUT.step;       
end
if isfield(INPUT,'orient')
    orient = INPUT.orient;  
else
    orient = 'Axial';
end
if isfield(INPUT,'rotation')
    rotation = INPUT.rotation;  
else
    rotation = 0;
end
if isfield(INPUT,'insets')
    insets = INPUT.insets;  
else
    insets = [0,0,0,0,0,0];
end
if isfield(INPUT,'fhand')
    fhand = INPUT.fhand;  
else
    fhand = [];
end
if isfield(INPUT,'figno')
    figno = INPUT.figno;  
else
    figno = [];
end
if isfield(INPUT,'slclbl')
    slclbl = INPUT.slclbl;  
else
    slclbl = 'Yes';
end
if isfield(INPUT,'usencolumns')
    ncolumns = INPUT.usencolumns;  
else
    ncolumns = [];
end
clear INPUT;

%---------------------------------------------
% Inset Tests
%---------------------------------------------
if strcmp(orient,'Axial')
    if insets(5)~=0 || insets(6)~=0
        err.flag = 1;
        err.msg = '''I'' and ''O'' Inset must be 0 for Axial';
        return
    end
end
if strcmp(orient,'Sagittal')
    if insets(3)~=0 || insets(4)~=0
        err.flag = 1;
        err.msg = '''L'' and ''R'' Inset must be 0 for Sagittal';
        return
    end
end
if strcmp(orient,'Coronal')
    if insets(1)~=0 || insets(2)~=0
        err.flag = 1;
        err.msg = '''A'' and ''P'' Inset must be 0 for Coronal';
        return
    end
end

%---------------------------------------------
% Inset
%---------------------------------------------
[x,y,z,~,~,~] = size(Image);
Image = Image(insets(1)+1:x-insets(2),insets(3)+1:y-insets(4),insets(6)+1:z-insets(5),:,:,:,:);

%---------------------------------------------
% Orientation
%---------------------------------------------
ImInfo = MSTRCT.ImInfo;
if strcmp(orient,'Axial')
    Image = Image;
elseif strcmp(orient,'Sagittal')
    Image = permute(Image,[3 1 2 4 5 6]);
    Image = flip(Image,1);
    ImInfo.pixdim = ImInfo.pixdim([3 1 2]);
elseif strcmp(orient,'Coronal')    
    Image = permute(Image,[3 2 1 4 5 6]);
    Image = flip(Image,1);
    Image = flip(Image,3);
    %--
    %Image = flip(Image,2);
    %--
    ImInfo.pixdim = ImInfo.pixdim([3 2 1]);
end
MSTRCT.ImInfo = ImInfo;

%---------------------------------------------
% Rotate
%---------------------------------------------
if strcmp(rotation,'-90')
    Image = permute(Image,[2 1 3]);
elseif strcmp(rotation,'90')
    Image = permute(Image,[2 1 3]);
    Image = flip(Image,1);
elseif strcmp(rotation,'180')
    Image = flip(Image,1);
end

%---------------------------------------------
% Determine Slices
%---------------------------------------------
if not(isempty(numberslices))
    sz = size(Image);
    if length(sz) == 2
        step = 1;
        stop = 1;
    else
        step = ceil(sz(3)/numberslices);
        stop = sz(3);
    end
    if step == 0
        step = 1;
    end
    start = floor(step/2);
    while true
        if length(start:step:stop) < numberslices
            start = start - 1;
        else
            break
        end
    end
    if start < 1
        if step > 1
            step = step - 1;
        end
        start = 1;
    end
    while true
        if length(start:step:stop) > numberslices
            start = start + 1;
            stop = stop - 1;
        else
            break
        end
    end    
end
sz = size(Image);
if length(sz) == 2
    MSTRCT.start = 1;
    MSTRCT.stop = 1;
    MSTRCT.step = 1;
else
    if stop > sz(3)
        stop = sz(3);
    end
    MSTRCT.start = start;
    MSTRCT.stop = stop;
    MSTRCT.step = step;
end
MSTRCT.slices = (MSTRCT.start:MSTRCT.step:MSTRCT.stop);
MSTRCT.totslices = length(MSTRCT.slices);

%----------------------------------------------
% Column Default
%----------------------------------------------
if isempty(ncolumns)
    Ratio0 = 5/3;
    sz = size(Image);
    num = length(MSTRCT.start:MSTRCT.step:MSTRCT.stop);
    for ncolumns = 1:20
        rows = ceil(num/ncolumns);
        horz = ncolumns*sz(2);
        vert = rows*sz(1);
        ratio(ncolumns) = horz/vert;
    end
    closest = min(abs(ratio-Ratio0));
    ncolumns = find(abs(ratio-Ratio0) == closest,1,'last');
end
if MSTRCT.totslices < ncolumns
    ncolumns = length(MSTRCT.slices);
end
MSTRCT.ncolumns = ncolumns;

%----------------------------------------------
% Slice Matrix
%----------------------------------------------
nrows = ceil(MSTRCT.totslices/MSTRCT.ncolumns);
reverseslices = [flip(MSTRCT.slices) zeros(1,100)];
ind = 1;
for m = 1:nrows
    for n = 1:ncolumns
        SliceMat(n,m) = reverseslices(ind);
        ind = ind+1;
    end
end                               
MSTRCT.SliceArray = SliceMat(:);                              % from top down

%----------------------------------------------
% Location Matrix (for Rois)
%----------------------------------------------
sz = size(Image);
if strcmp(orient,'Axial')
    vstart = insets(1);
    vdim = sz(1);
    hstart = insets(3);
    hdim = sz(2);    
end
Vadd = -vstart+(0:nrows-1)*vdim; 
Hadd = -hstart+(0:ncolumns-1)*hdim; 
[VaddMat,HaddMat] = meshgrid(Vadd,Hadd);
MSTRCT.Hadd = HaddMat(:);
MSTRCT.Vadd = VaddMat(:);

%----------------------------------------------
% Other
%----------------------------------------------
MSTRCT.imsize = [];
MSTRCT.slclbl = slclbl;
MSTRCT.lblvals = flip(start:step:stop);
if strcmp(orient,'Coronal') 
   MSTRCT.lblvals = flip(MSTRCT.lblvals);
   start0 = MSTRCT.start;
   MSTRCT.start = sz(3)-MSTRCT.stop+1;
   MSTRCT.stop = sz(3)-start0+1;
end

%---------------------------------------------
% Return
%---------------------------------------------
MCHRS.MSTRCT = MSTRCT;
MCHRS.Image = Image;

