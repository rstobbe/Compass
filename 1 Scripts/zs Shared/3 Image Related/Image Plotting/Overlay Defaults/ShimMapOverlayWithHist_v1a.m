%=========================================================
% 
%=========================================================

function [MOF,err] = ShimMapOverlayWithHist_v1a(INPUT)

Status2('busy','Plot Shim Figures',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
MOF = struct();

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
MSTRCT = INPUT.MSTRCT;
if isfield(INPUT,'Name1')
    Name1 = INPUT.Name1;
else
    Name1 = 'Original';
end
if isfield(INPUT,'Name2')
    Name2 = INPUT.Name2;
else
    Name2 = 'Shim Projection';
end
if isfield(INPUT,'returnmont')
    returnmont = INPUT.returnmont;
else
    returnmont = 'No';
end
if isfield(INPUT,'dispwid1')
    dispwid1 = INPUT.dispwid1;
else
    dispwid1 = [];
end
if isfield(INPUT,'dispwid2')
    dispwid2 = INPUT.dispwid2;
else
    dispwid2 = [];
end
if isfield(INPUT,'intensity')
    intensity = INPUT.intensity;
else
    intensity = 'Flat50';
end
if isfield(INPUT,'histcolor')
    histcolor = INPUT.histcolor;
else
    histcolor = 'b';
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
Map1 = squeeze(Image(:,:,:,1));
Map2 = squeeze(Image(:,:,:,2));
BaseIm = squeeze(Image(:,:,:,3));

%----------------------------------------------
% Base Image
%----------------------------------------------
dispwid0 = [0 0.9*max(abs(BaseIm(:)))];
MSTRCT.dispwid1 = dispwid0;

%----------------------------------------------
% Image Aspects
%----------------------------------------------
MSTRCT.intensity = intensity;
MSTRCT.type1 = 'abs';
MSTRCT.type2 = 'real';

%---------------------------------------------
% Columns
%---------------------------------------------
Ratio0 = (5/3);
sz = size(Map1);
num = length(MSTRCT.start:MSTRCT.step:MSTRCT.stop);
for ncolumns = 1:20
    rows = ceil(num/ncolumns);
    horz = ncolumns*sz(2);
    vert = rows*sz(1);
    ratio(ncolumns) = horz/vert;
end
MSTRCT.ncolumns = find(ratio <= Ratio0,1,'last');    

%----------------------------------------------
% Display Width
%----------------------------------------------
if isempty(dispwid1)
    dispwid1(1) = -max(abs(Map1(:)));
    dispwid1(2) = -dispwid1(1);
end
MSTRCT.dispwid2 = dispwid1;

%----------------------------------------------
% Plot Image1
%----------------------------------------------
MSTRCT.ahand = axes('parent',MSTRCT.fhand);
MSTRCT.ahand.Position = [0.05,0.525,0.45,0.425];
INPUT.MSTRCT = MSTRCT;
INPUT.Image = cat(4,BaseIm,Map1);
[Img,err] = PlotMontageOverlay_v1e(INPUT);
if strcmp(returnmont,'Yes')
    MOF.Img = Img;
end
title(MSTRCT.ahand,Name1);

%---------------------------------------------
% Plot Histogram1
%---------------------------------------------
histahand = axes('parent',MSTRCT.fhand);
histahand.Position = [0.55,0.55,0.4,0.375];
test = Map1(:);
test = test(not(isnan(test)));
cens = linspace(dispwid1(1),dispwid1(2),500);
[nels,cens] = hist(test,cens);
nels = smooth(nels,5,'moving');
plot(cens,nels,histcolor,'Parent',histahand);
histahand.XLim = [dispwid1(1),dispwid1(2)];
xlabel('B0 (Hz)'); ylabel('Voxels');
title(histahand,[Name1,' Histogram']);

%----------------------------------------------
% Display Width
%----------------------------------------------
if isempty(dispwid2)
    dispwid2(1) = -max(abs(Map1(:)));
    dispwid2(2) = -dispwid2(1);
end
MSTRCT.dispwid2 = dispwid2;

%----------------------------------------------
% Plot Image2
%----------------------------------------------
MSTRCT.ahand = axes('parent',MSTRCT.fhand);
MSTRCT.ahand.Position = [0.05,0.05,0.45,0.425];
INPUT.MSTRCT = MSTRCT;
INPUT.Image = cat(4,BaseIm,Map2);
[Img,err] = PlotMontageOverlay_v1e(INPUT);
if strcmp(returnmont,'Yes')
    MOF.Img = Img;
end
title(MSTRCT.ahand,Name2);

%---------------------------------------------
% Plot Histogram2
%---------------------------------------------
histahand = axes('parent',MSTRCT.fhand);
histahand.Position = [0.55,0.075,0.4,0.375];
test = Map2(:);
test = test(not(isnan(test)));
cens = linspace(dispwid2(1),dispwid2(2),500);
[nels,cens] = hist(test,cens);
nels = smooth(nels,5,'moving');
plot(cens,nels,histcolor,'Parent',histahand);
histahand.XLim = [dispwid2(1),dispwid2(2)];
xlabel('B0 (Hz)'); ylabel('Voxels');
title(histahand,[Name2,' Histogram']);

%---------------------------------------------
% Return for Save
%---------------------------------------------
fig = 1;
MOF.Figure(fig).Name = 'ShimMap';
MOF.Figure(fig).Type = 'NoEps';
MOF.Figure(fig).hFig = MSTRCT.fhand;
MOF.Figure(fig).hAx = MSTRCT.ahand;

Status2('done','',2);
Status2('done','',3);
