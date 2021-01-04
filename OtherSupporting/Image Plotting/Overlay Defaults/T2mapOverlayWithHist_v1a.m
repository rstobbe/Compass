%=========================================================
% 
%=========================================================

function [MOF,err] = T2mapOverlayWithHist_v1a(INPUT)

Status2('busy','Plot B1map Figures',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
MOF = struct();

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
MSTRCT = INPUT.MSTRCT;
if isfield(INPUT,'Name')
    Name = INPUT.Name;
else
    Name = 'T2Map';
end
if isfield(INPUT,'returnmont')
    returnmont = INPUT.returnmont;
else
    returnmont = 'No';
end
if isfield(INPUT,'dispwid')
    dispwid = INPUT.dispwid;
else
    dispwid = [];
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
BaseIm = squeeze(Image(:,:,:,end));
Map = squeeze(Image(:,:,:,1));

%----------------------------------------------
% Base Image
%----------------------------------------------
dispwid1 = [0 0.9*max(abs(BaseIm(:)))];
MSTRCT.dispwid1 = dispwid1;

%----------------------------------------------
% Image Aspects
%----------------------------------------------
MSTRCT.intensity = intensity;
MSTRCT.type1 = 'abs';
MSTRCT.type2 = 'real';

%----------------------------------------------
% Display Width
%----------------------------------------------
if isempty(dispwid)
    dispwid(1) = 0;
    dispwid(2) = max(abs(Map(:)));
    dispwid(2) = 10;
end
MSTRCT.dispwid2 = dispwid;

%---------------------------------------------
% Create New Axis
%---------------------------------------------
MSTRCT.ahand = axes('parent',MSTRCT.fhand);
MSTRCT.ahand.Position = [0.05,0,0.45,1];

%---------------------------------------------
% Columns
%---------------------------------------------
Ratio0 = 1;
sz = size(Map);
num = length(MSTRCT.start:MSTRCT.step:MSTRCT.stop);
for ncolumns = 1:20
    rows = ceil(num/ncolumns);
    horz = ncolumns*sz(2);
    vert = rows*sz(1);
    ratio(ncolumns) = horz/vert;
end
MSTRCT.ncolumns = find(ratio <= Ratio0,1,'last');    

%----------------------------------------------
% Plot Image
%----------------------------------------------
INPUT.MSTRCT = MSTRCT;
INPUT.Image = cat(4,Map,BaseIm);
[Img,err] = PlotMontageOverlay_v1e(INPUT);
if strcmp(returnmont,'Yes')
    MOF.Img = Img;
end
title(Name);

%---------------------------------------------
% Plot Histogram
%---------------------------------------------
histahand = axes('parent',MSTRCT.fhand);
histahand.Position = [0.55,0.1,0.4,0.8];
test = Map(:);
test = test(not(isnan(test)));
cens = linspace(dispwid(1),dispwid(2),250);
[nels,cens] = hist(test,cens);
nels = smooth(nels,5,'moving');
plot(cens,nels,histcolor,'Parent',histahand);
xlabel('B1'); ylabel('Voxels');
title([Name,' Histogram']);

Status2('done','',2);
Status2('done','',3);
