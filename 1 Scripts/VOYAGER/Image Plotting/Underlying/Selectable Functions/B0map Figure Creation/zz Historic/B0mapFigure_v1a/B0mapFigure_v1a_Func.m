%=========================================================
% 
%=========================================================

function [MOF,err] = B0mapFigure_v1a_Func(MOF,INPUT)

Status2('busy','Plot B0map Figures',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
MSTRCT = INPUT.MSTRCT;
DPROPS = INPUT.DPROPS;
scale = [];
if isfield(DPROPS,'scale');
    scale = DPROPS.scale;
end
figno = [];
if isfield(DPROPS,'figno');
    figno = DPROPS.figno;
end
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
% Plot B0 Map
%----------------------------------------------
if isempty(figno)
    MSTRCT.figno = '1000';
else
    MSTRCT.figno = num2str(figno);
end
if isempty(scale)
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
else
    MSTRCT.dispwid = scale;
    dispwid(1) = scale(1);
    dispwid(2) = scale(2);
end
    
INPUT.MSTRCT = MSTRCT;
INPUT.Image = Map;
[err] = PlotMontage_v1a(INPUT);
title('B0 Map (Hz)');

%---------------------------------------------
% Plot Histogram
%---------------------------------------------
test = Map(:);
test = test(not(isnan(test)));
figure(2000); hold on;
cens = linspace(dispwid(1),dispwid(2),1000);
[nels,cens] = hist(test,cens);
nels = smooth(nels,5,'moving');
plot(cens,nels,'b');
xlabel('B0 (Hz)'); ylabel('Voxels');
title('B0 Histogram');


Status2('done','',2);
Status2('done','',3);
