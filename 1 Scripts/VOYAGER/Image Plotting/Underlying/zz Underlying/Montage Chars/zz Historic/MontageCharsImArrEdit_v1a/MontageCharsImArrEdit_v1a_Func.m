%=========================================================
% 
%=========================================================

function [MCHRS,err] = MontageCharsImArrEdit_v1a_Func(MCHRS,INPUT)

Status2('busy','Return Montage Chars',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Image = INPUT.Image;
MSTRCT = INPUT.MSTRCT;
clear INPUT;

%---------------------------------------------
% Select Image from Image Array
%---------------------------------------------
sz = size(Image);
if MCHRS.imnum(1) == 1
    Image = Image(MCHRS.imnum(2),:,:,:);
elseif MCHRS.imnum(1) == 2
    Image = Image(:,MCHRS.imnum(2),:,:);
elseif MCHRS.imnum(1) == 3
    Image = Image(:,:,MCHRS.imnum(2),:);    
elseif MCHRS.imnum(1) == 4
    Image = Image(:,:,:,MCHRS.imnum(2));
elseif MCHRS.imnum(1) == 5
    Image = Image(:,:,:,:,MCHRS.imnum(2));
end
Image = squeeze(Image);

%---------------------------------------------
% Get Variables
%---------------------------------------------
orient = MCHRS.orient;
rotation = MCHRS.rotation;
slices = MCHRS.slices;
insets = MCHRS.insets;   

%---------------------------------------------
% Determine Slices
%---------------------------------------------
if strcmp(slices,'All')
    start = 1;
    step = 1;
    sz = size(Image);
    stop = max(sz);
else
    inds = strfind(slices,':');
    if isempty(inds)
        start = str2double(slices);
        stop = str2double(slices);
        step = 1;
    else
        start = str2double(slices(1:inds(1)-1));
        step = str2double(slices(inds(1)+1:inds(2)-1));
        stop = str2double(slices(inds(2)+1:length(slices))); 
    end
end 

%---------------------------------------------
% Determine Insets
%---------------------------------------------
inds = strfind(insets,',');
A = str2double(insets(1:inds(1)-1));
P = str2double(insets(inds(1)+1:inds(2)-1));
L = str2double(insets(inds(2)+1:inds(3)-1)); 
R = str2double(insets(inds(3)+1:inds(4)-1));
T = str2double(insets(inds(4)+1:inds(5)-1)); 
B = str2double(insets(inds(5)+1:length(insets))); 

%---------------------------------------------
% Inset
%---------------------------------------------
[x,y,z,d] = size(Image);
Image = Image(A+1:x-P,L+1:y-R,T+1:z-B,:);

%---------------------------------------------
% Orientation
%---------------------------------------------
if strcmp(orient,'Axial')
    Image = Image;
elseif strcmp(orient,'Sagittal')
    Image = permute(Image,[1 3 2 4]);
elseif strcmp(orient,'Coronal')    
    Image = permute(Image,[3 2 1]);
end

%---------------------------------------------
% Rotate
%---------------------------------------------
if strcmp(rotation,'-90')
    Image = permute(Image,[2 1 3]);
elseif strcmp(rotation,'90')
    Image = permute(Image,[2 1 3]);
    Image = flipdim(Image,1);
elseif strcmp(rotation,'180')
    Image = flipdim(Image,1);
end

%---------------------------------------------
% Test
%---------------------------------------------
[x,y,z,d] = size(Image);
if stop > z
    stop = z;
end

%---------------------------------------------
% MSTRCT
%---------------------------------------------
MSTRCT.start = start;
MSTRCT.stop = stop;
MSTRCT.step = step;

%---------------------------------------------
% Return
%---------------------------------------------
MCHRS.MSTRCT = MSTRCT;
MCHRS.Image = Image;

Status2('done','',2);
Status2('done','',3);
