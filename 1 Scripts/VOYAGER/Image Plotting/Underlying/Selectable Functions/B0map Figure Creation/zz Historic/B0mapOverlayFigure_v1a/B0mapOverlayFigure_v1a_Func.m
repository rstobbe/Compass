%=========================================================
% 
%=========================================================

function [MOF,err] = B0mapOverlayFigure_v1a_Func(MOF,INPUT)

Status2('busy','Plot B0map Figures',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
MSTRCT = INPUT.MSTRCT;
if isfield(INPUT,'Name');
    Name = INPUT.Name;
else
    Name = 'B0Map';
end
if isfield(INPUT,'DPROPS')
    DPROPS = INPUT.DPROPS;    
    if isempty(DPROPS)
        DPROPS.hist = 'Yes';
        DPROPS.returnmont = 'No';
    else
        if isfield(DPROPS,'figno')
            MSTRCT.figno = DPROPS.figno;
        end
    end
else
    DPROPS.hist = 'Yes';
    DPROPS.returnmont = 'No';
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
BaseIm = squeeze(Image(:,:,:,1));
Map = squeeze(Image(:,:,:,2));

%----------------------------------------------
% Base Image
%----------------------------------------------
dispwid1 = [0 0.9*max(abs(BaseIm(:)))];
MSTRCT.dispwid1 = dispwid1;

%----------------------------------------------
% Image Aspects
%----------------------------------------------
MSTRCT.intensity = 'Flat50';
MSTRCT.type1 = 'abs';
MSTRCT.type2 = 'real';

%----------------------------------------------
% Plot Original Full Image
%----------------------------------------------
if strcmp(MOF.scale,'Full')
    dispwid(1) = -max(abs(Map(:)));
    dispwid(2) = -dispwid(1);
    MSTRCT.dispwid2 = dispwid;
else
    ind = strfind(MOF.scale,',');
    MSTRCT.dispwid2(1) = str2double(MOF.scale(1:ind-1));
    MSTRCT.dispwid2(2) = str2double(MOF.scale(ind+1:end));
    dispwid(1) = MSTRCT.dispwid2(1);
    dispwid(2) = MSTRCT.dispwid2(2);
end
INPUT.MSTRCT = MSTRCT;
INPUT.Image(:,:,:,1) = BaseIm;
INPUT.Image(:,:,:,2) = Map;
[Img,err] = PlotMontageOverlay_v1d(INPUT);
if strcmp(DPROPS.returnmont,'Yes')
    MOF.Img = Img;
end
title(Name);

%---------------------------------------------
% Plot Histogram
%---------------------------------------------
if strcmp(DPROPS.hist,'Yes')
    test = Map(:);
    test = test(not(isnan(test)));
    figure(2000); hold on;
    cens = linspace(dispwid(1),dispwid(2),250);
    [nels,cens] = hist(test,cens);
    nels = smooth(nels,5,'moving');
    plot(cens,nels,'b');
    xlabel('B0 (Hz)'); ylabel('Voxels');
    title([Name,' Histogram']);
end


Status2('done','',2);
Status2('done','',3);
