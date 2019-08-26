%=========================================================
% 
%=========================================================

function [MCHRS,err] = MontageCharsShimV_v1a_Func(MCHRS,INPUT)

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
% Return Standard
%---------------------------------------------
MSTRCT.orient = 'Axial';
MSTRCT.rotation = 0;
MSTRCT.slices = [];
MSTRCT.insets = '5,5,5,5,0,0';

%---------------------------------------------
% Determine Insets
%---------------------------------------------
inds = strfind(MSTRCT.insets,',');
A = str2double(MSTRCT.insets(1:inds(1)-1));
P = str2double(MSTRCT.insets(inds(1)+1:inds(2)-1));
L = str2double(MSTRCT.insets(inds(2)+1:inds(3)-1)); 
R = str2double(MSTRCT.insets(inds(3)+1:inds(4)-1));
T = str2double(MSTRCT.insets(inds(4)+1:inds(5)-1)); 
B = str2double(MSTRCT.insets(inds(5)+1:length(MSTRCT.insets))); 

%---------------------------------------------
% Inset
%---------------------------------------------
[x,y,z,d] = size(Image);
Image = Image(A+1:x-P,L+1:y-R,T+1:z-B,:);

%---------------------------------------------
% MSTRCT
%---------------------------------------------
MSTRCT.start = 5;
MSTRCT.stop = 32;
MSTRCT.step = 1;

%---------------------------------------------
% Return
%---------------------------------------------
MCHRS.MSTRCT = MSTRCT;
MCHRS.Image = Image;

Status2('done','',3);
