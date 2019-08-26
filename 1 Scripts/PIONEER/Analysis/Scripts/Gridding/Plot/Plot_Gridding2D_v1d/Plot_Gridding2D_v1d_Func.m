%=========================================================
% 
%=========================================================

function [OUTPUT,err] = Plot_Gridding2D_v1d_Func(INPUT)

Status('busy','Plot Gridding 2D');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
GRD = INPUT.GRD;
GrdDat = GRD.GrdDat;
Ksz = GRD.Ksz;
PLOT = INPUT.PLOT;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
type = PLOT.type;
minval = PLOT.minval;
maxval = PLOT.maxval;
colour = PLOT.colour;
figno = PLOT.figno;

%---------------------------------------------
% Type
%---------------------------------------------
if strcmp(type,'abs')
    GrdDat = abs(GrdDat);
elseif strcmp(type,'phase')
    GrdDat = angle(GrdDat);
end

%---------------------------------------------
% Determine Figure
%---------------------------------------------
if strcmp(figno,'Continue')
    fighand = figure;
else
    fighand = str2double(figno);
end 
   
figure(fighand);
imshow(abs(GrdDat),[minval maxval]);
truesize(gcf,[250 250]);
if strcmp(colour,'Colour')
    load('ColorMap4');
    colormap(mycolormap); 
end
caxis([minval maxval]);
colorbar;
axis off;
axis image;
set(gcf,'PaperPositionMode','auto');

