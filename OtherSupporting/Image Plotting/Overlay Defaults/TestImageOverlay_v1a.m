%=========================================================
% 
%=========================================================

function [MOF,err] = TestImageOverlay_v1a(INPUT)

Status2('busy','Plot Test Image Overlay',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
MOF = struct();

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
if isfield(INPUT,'returnmont');
    returnmont = INPUT.returnmont;
else
    returnmont = 'No';
end
if isfield(INPUT,'dispwid');
    dispwid = INPUT.dispwid;
else
    dispwid = [];
end
if isfield(INPUT,'intensity');
    intensity = INPUT.intensity;
else
    intensity = 'Flat50';
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
BaseIm = squeeze(Image(:,:,:,2));
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
    dispwid(1) = -max(abs(Map(:)));
    dispwid(2) = -dispwid(1);
end
MSTRCT.dispwid2 = dispwid;

%---------------------------------------------
% Create New Axis
%---------------------------------------------
MSTRCT.ahand = axes('parent',MSTRCT.fhand);
MSTRCT.ahand.Position = [0,0,1,1];

%---------------------------------------------
% Columns
%---------------------------------------------
if not(isfield(MSTRCT,'ncolumns'))
    MSTRCT.ncolumns = [];
end
if isempty(MSTRCT.ncolumns)
    Ratio0 = 5/3;
    sz = size(Map);
    num = length(MSTRCT.start:MSTRCT.step:MSTRCT.stop);
    for ncolumns = 1:20
        rows = ceil(num/ncolumns);
        horz = ncolumns*sz(2);
        vert = rows*sz(1);
        ratio(ncolumns) = horz/vert;
    end
    MSTRCT.ncolumns = find(ratio <= Ratio0,1,'last');    
end

%----------------------------------------------
% Plot Image
%----------------------------------------------
INPUT.MSTRCT = MSTRCT;
INPUT.Image = Image;
[Img,err] = PlotMontageOverlay_v1e(INPUT);
if strcmp(returnmont,'Yes')
    MOF.Img = Img;
end
title(Name);

Status2('done','',2);
Status2('done','',3);
