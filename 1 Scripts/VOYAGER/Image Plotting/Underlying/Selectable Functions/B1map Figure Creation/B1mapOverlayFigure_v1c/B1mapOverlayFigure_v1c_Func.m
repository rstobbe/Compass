%=========================================================
% 
%=========================================================

function [MOF,err] = B1mapOverlayFigure_v1c_Func(MOF,INPUT)

Status2('busy','Plot B1map Figures',2);
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
if length(sz) == 3
    err.flag = 1;
    err.msg = 'Createfunc Not Valid For Image';
    return
end

%----------------------------------------------
% Test
%----------------------------------------------
if strcmp(MOF.type,'dB')
	Image(:,:,:,1) = 10*log10(Image(:,:,:,1));
end
    
%----------------------------------------------
% Get Scale
%----------------------------------------------
Map = squeeze(Image(:,:,:,1));
if strcmp(MOF.scale,'Full')
    dispwid(1) = 0;
    dispwid(2) = max(abs(Map(:)));
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
% Create Image
%----------------------------------------------
INPUT.intensity = 'Flat50';
INPUT.dispwid = dispwid;
INPUT.Image = Image;
INPUT.MSTRCT = MSTRCT;
INPUT.Name = Name;
if strcmp(MOF.histogram,'Yes')
    [MOF,err] = B1mapOverlayWithHist_v1a(INPUT);
end

%---------------------------------------------
% Image Size
%---------------------------------------------
if isempty(MSTRCT.imsize)
   MSTRCT.imsize = [500 500];
end
truesize(MSTRCT.fhand,MSTRCT.imsize);

Status2('done','',2);
Status2('done','',3);
