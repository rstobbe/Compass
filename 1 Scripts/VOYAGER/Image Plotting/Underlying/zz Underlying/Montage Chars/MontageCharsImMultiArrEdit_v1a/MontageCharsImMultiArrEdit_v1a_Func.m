%=========================================================
% 
%=========================================================

function [MCHRS,err] = MontageCharsImMultiArrEdit_v1a_Func(MCHRS,INPUT)

Status2('busy','Get Montage Params',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Image = INPUT.Image;
MSTRCT = INPUT.MSTRCT;
clear INPUT;

%---------------------------------------------
% Get Variables
%---------------------------------------------
orient = MCHRS.orient;
index = MCHRS.index;
insets = MCHRS.insets;   

%---------------------------------------------
% Determine Indexing
%---------------------------------------------
inds = strfind(index,',');
dim{1} = index(1:inds(1)-1);
for n = 2:length(inds);
    dim{n} = index(inds(n-1)+1:inds(n)-1);
end
dim{n+1} = index(inds(n)+1:end);

%---------------------------------------------
% Test
%---------------------------------------------
sz = size(Image);
if length(dim) ~= length(sz)
    err.flag = 1;
    err.msg = 'Inconsistant Dimensions';
    return
end

%---------------------------------------------
% Interpret Indexing
%---------------------------------------------
idx{4} = 1;
idx{5} = 1;
for n = 1:length(dim)
    inds = strfind(dim{n},':');
    if isempty(inds)
        idx{n} = str2double(dim{n});
    else
        if length(dim{n}) == 1
            idx{n} = (1:sz(n));
        else
            start = str2double(dim{n}(1:inds(1)-1));
            step = str2double(dim{n}(inds(1)+1:inds(2)-1));
            stop = str2double(dim{n}(inds(2)+1:length(dim{n}))); 
            idx{n} = (start:step:stop);
        end
    end
end

%---------------------------------------------
% Get Image SubSet
%---------------------------------------------
ImageNew = squeeze(Image(idx{1},idx{2},idx{3},idx{4},idx{5}));
test = size(ImageNew);
if length(test) > 3
    err.flag = 1;
    err.msg = 'Indexed Image Should be 3D';
    return
end

%---------------------------------------------
% Test
%---------------------------------------------
[x,y,z,~,~,~] = size(Image);
if strcmp(orient,'Axial')
    if length(idx{1}) ~= sz(1) || length(idx{2}) ~= sz(2)
        err.flag = 1;
        err.msg = 'X and Y must not be subindexed for Axial';
        return
    end
    inds = strfind(insets,',');
    A = str2double(insets(1:inds(1)-1));
    P = str2double(insets(inds(1)+1:inds(2)-1));
    L = str2double(insets(inds(2)+1:inds(3)-1)); 
    R = str2double(insets(inds(3)+1:inds(4)-1));
    ImageNew = ImageNew(A+1:x-P,L+1:y-R,:);
elseif strcmp(orient,'Sagittal')
    error; % finish
    %permute rotate as needed
end
   
%---------------------------------------------
% MSTRCT
%---------------------------------------------
sz = size(ImageNew);
MSTRCT.start = 1;
MSTRCT.stop = sz(3);
MSTRCT.step = 1;
MSTRCT.ncolumns = MCHRS.ncolumns;

%---------------------------------------------
% Normalize Each Slice
%---------------------------------------------
if strcmp(MCHRS.Normalize,'Each_Image')
    for n = 1:sz(3)
        tImage = abs(ImageNew(:,:,n));
        ImageNew(:,:,n) = ImageNew(:,:,n)/(max(tImage(:)));
    end
end

%---------------------------------------------
% Return
%---------------------------------------------
MCHRS.MSTRCT = MSTRCT;
MCHRS.Image = ImageNew;

Status2('done','',2);
Status2('done','',3);
