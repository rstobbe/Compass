%=========================================================
% 
%=========================================================

function [MOF,err] = B1mapFigure_v1a_Func(MOF,INPUT)

Status2('busy','Plot B1map Figures',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
MSTRCT = INPUT.MSTRCT;
clear INPUT

%----------------------------------------------
% Test
%----------------------------------------------
sz = size(Image);
if length(sz) == 3
    err.flag = 1;
    err.msg = 'Createfunc Not Valid For Image';
    return
end
Map = squeeze(Image(:,:,:,2));

%----------------------------------------------
% Image Aspects
%----------------------------------------------
MSTRCT.type = 'real';
MSTRCT.colour = 'Yes';

%----------------------------------------------
% Plot B1 Map
%----------------------------------------------
MSTRCT.figno = '1000';
if strcmp(MOF.scale,'Full')
    dispwid(1) = -max(abs(Map(:)));
    dispwid(2) = -dispwid(1);
    MSTRCT.dispwid = dispwid;
else
    ind = strfind(MOF.scale,',');
    MSTRCT.dispwid(1) = str2double(MOF.scale(1:ind-1));
    MSTRCT.dispwid(2) = str2double(MOF.scale(ind+1:end));
    dispwid(1) = MSTRCT.dispwid(1);
    dispwid(2) = MSTRCT.dispwid(2);
end
INPUT.MSTRCT = MSTRCT;
INPUT.Image = Map;
[err] = PlotMontage_v1a(INPUT);
title('B1 Map');

%---------------------------------------------
% Plot Original Full Histogram
%---------------------------------------------
test = Map(:);
test = test(not(isnan(test)));
figure(2000); hold on;
cens = linspace(dispwid(1),dispwid(2),1000);
[nels,cens] = hist(test,cens);
nels = smooth(nels,5,'moving');
plot(cens,nels,'b');
xlabel('Relative B1'); ylabel('Voxels');
title('B1 Histogram');


Status2('done','',2);
Status2('done','',3);
