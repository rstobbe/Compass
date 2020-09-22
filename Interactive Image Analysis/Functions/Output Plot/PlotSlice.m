%=========================================================
% 
%=========================================================

function PlotSlice(tab,axnum)

global IMAGEANLZ
global FIGOBJS

%----------------------------------------
% Get Info
%----------------------------------------
Image = IMAGEANLZ.(tab)(axnum).GetCurrentImageSlice;

%cLim = IMAGEANLZ.(tab)(axnum).GetContrastLimit;
%Image = Image/cLim(2);
%xlim = IMAGEANLZ.(tab)(axnum).GetXAxisLimits

%----------------------------------------
% Plot
%----------------------------------------
%imwrite(Image,'TestPng16.png','BitDepth',16);
%imwrite(Image,'TestTifNoComp.tif','Compression','none');
%return

%----------------------------------------
% Plot
%----------------------------------------
fighand = figure;
axhand = axes('parent',fighand);

iptsetpref('ImshowBorder','tight');
h = imshow(Image);
h.CDataMapping = 'scaled';

axhand.DataAspectRatio = IMAGEANLZ.(tab)(axnum).GetPixelDimensions;
axhand.CLim = IMAGEANLZ.(tab)(axnum).GetContrastLimit;
axhand.XTick = [];
axhand.YTick = [];
axhand.XLim = round(IMAGEANLZ.(tab)(axnum).GetXAxisLimits);
axhand.YLim = round(IMAGEANLZ.(tab)(axnum).GetYAxisLimits);
colormap(axhand,FIGOBJS.Options.GrayMap);

%axhand.Position = [0 0 0.5 0.5];

%----------------------------------------
% Fix Border
%----------------------------------------
xlims = axhand.XLim;
xdim = xlims(2) - xlims(1);
ylims = axhand.YLim;
ydim = ylims(2) - ylims(1);
factor = round(400/xdim);
pos = [600 300 xdim*factor ydim*factor];
fighand.Position = pos;

%----------------------------------------
% Draw ROIs
%----------------------------------------
IMAGEANLZ.(tab)(axnum).DrawSavedROIs(axhand);
