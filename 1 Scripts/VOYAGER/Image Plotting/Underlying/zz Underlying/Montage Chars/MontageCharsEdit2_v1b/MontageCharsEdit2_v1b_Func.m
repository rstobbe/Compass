%=========================================================
% 
%=========================================================

function [MCHRS,err] = MontageCharsEdit2_v1b_Func(MCHRS,INPUT)

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
INPUT.numberslices = slices;
INPUT.Image = Image;
INPUT.MSTRCT = MSTRCT;
[MCHRS,err] = DefaultMontageChars_v1a(INPUT);

Status2('done','',3);


