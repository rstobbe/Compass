%=========================================================
% 
%=========================================================

function [MOF,err] = MapNoOverlay_v1a(INPUT)

Status2('busy','Plot Map',2);
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
    Name = 'B0Map';
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
clear INPUT

%----------------------------------------------
% Test
%----------------------------------------------
sz = size(Image);
if length(sz) ~= 3
    err.flag = 1;
    err.msg = 'Createfunc Not Valid For Image';
    return
end
Map = Image;

%----------------------------------------------
% Image Aspects
%----------------------------------------------
MSTRCT.type = 'real';

%----------------------------------------------
% Display Width
%----------------------------------------------
if isempty(dispwid)
    dispwid(1) = -max(abs(Map(:)));
    dispwid(2) = -dispwid(1);
end
MSTRCT.dispwid = dispwid;

%---------------------------------------------
% Create New Axis
%---------------------------------------------
MSTRCT.ahand = axes('parent',MSTRCT.fhand);

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
INPUT.Image = Image;
[Img,err] = PlotMontageImage_v1e(INPUT);
colorbar('peer',Img.handles.ahand);
if strcmp(returnmont,'Yes')
    MOF.Img = Img;
end
inds = strfind(Name,'_');
Name(inds) = '-';
title(Name);

Status2('done','',2);
Status2('done','',3);
