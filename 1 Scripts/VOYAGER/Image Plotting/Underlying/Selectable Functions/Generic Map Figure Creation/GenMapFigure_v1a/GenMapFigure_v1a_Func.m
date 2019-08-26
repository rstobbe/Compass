%=========================================================
% 
%=========================================================

function [MOF,err] = GenMapFigure_v1a_Func(MOF,INPUT)

Status2('busy','Plot Map',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
MSTRCT = INPUT.MSTRCT;
Name = INPUT.Name;
clear INPUT;

%----------------------------------------------
% Test
%----------------------------------------------
sz = size(Image);
if length(sz) ~= 3
    err.flag = 1;
    err.msg = 'Createfunc Not Valid For Image';
    return
end

%----------------------------------------------
% Get Scale
%----------------------------------------------
Map = squeeze(Image(:,:,:,1));
if strcmp(MOF.scale,'Full')
    dispwid(1) = -max(abs(Map(:)));
    dispwid(2) = -dispwid(1);
else
    ind = strfind(MOF.scale,',');
    dispwid(1) = str2double(MOF.scale(1:ind-1));
    dispwid(2) = str2double(MOF.scale(ind+1:end));
end

%----------------------------------------------
% Create New Figure
%----------------------------------------------
MSTRCT.fhand = figure;

%----------------------------------------------
% Colour
%----------------------------------------------
if strcmp(MOF.colour,'Yes')
    MSTRCT.colour = 'Yes';
end
MSTRCT.slclbl = 'No';

%----------------------------------------------
% Create Image
%----------------------------------------------
INPUT.dispwid = dispwid;
INPUT.Image = Image;
INPUT.MSTRCT = MSTRCT;
INPUT.Name = Name;
[MOF,err] = MapNoOverlay_v1a(INPUT);

Status2('done','',2);
Status2('done','',3);
