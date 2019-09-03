%=========================================================
% 
%=========================================================

function [MCHRS,err] = MontageCharsEdit1_v1b_Func(MCHRS,INPUT)

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
% Determine Columns
%---------------------------------------------
if isempty(MCHRS.ncolumns)
    ncolumns = [];
else
    ncolumns = str2double(MCHRS.ncolumns);
end

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
INPUT.usencolumns = ncolumns;
INPUT.MSTRCT = MSTRCT;
%[MCHRS,err] = DefaultMontageChars_v1a(INPUT);
[MCHRS,err] = DefaultMontageChars_v1b(INPUT);               % not changes just additions

Status2('done','',3);


