%=========================================================
% 
%=========================================================

function [MCHRS,err] = MontageCharsImArrEdit1_v1b_Func(MCHRS,INPUT)

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
ind = strfind(MCHRS.imnum,',');
if isempty(ind)
    error;
else
    num1 = str2double(MCHRS.imnum(1:ind-1));
    num2 = str2double(MCHRS.imnum(ind+1:end));
    MCHRS.imnum = [num1 num2];
end

sz = size(Image);
if MCHRS.imnum(1) == 1
    Image = Image(MCHRS.imnum(2),:,:,:,:,:);
elseif MCHRS.imnum(1) == 2
    Image = Image(:,MCHRS.imnum(2),:,:,:,:);
elseif MCHRS.imnum(1) == 3
    Image = Image(:,:,MCHRS.imnum(2),:,:,:);    
elseif MCHRS.imnum(1) == 4
    Image = Image(:,:,:,MCHRS.imnum(2),:,:);
elseif MCHRS.imnum(1) == 5
    Image = Image(:,:,:,:,MCHRS.imnum(2),:);
elseif MCHRS.imnum(1) == 6
    Image = Image(:,:,:,:,:,MCHRS.imnum(2));
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
insetarr(1) = str2double(insets(1:inds(1)-1));
insetarr(2) = str2double(insets(inds(1)+1:inds(2)-1));
insetarr(3) = str2double(insets(inds(2)+1:inds(3)-1)); 
insetarr(4) = str2double(insets(inds(3)+1:inds(4)-1));
insetarr(5) = str2double(insets(inds(4)+1:inds(5)-1)); 
insetarr(6) = str2double(insets(inds(5)+1:length(insets))); 

%---------------------------------------------
% Return Chars
%---------------------------------------------
INPUT.orient = orient;
INPUT.rotation = rotation;
INPUT.insets = insetarr;
INPUT.figno = 'Continue';
INPUT.start = start;
INPUT.step = step;
INPUT.stop = stop;
INPUT.numberslices = [];
INPUT.Image = Image;
INPUT.usencolumns = MCHRS.ncolumns;
INPUT.MSTRCT = MSTRCT;
[MCHRS,err] = DefaultMontageChars_v1a(INPUT);

Status2('done','',3);
