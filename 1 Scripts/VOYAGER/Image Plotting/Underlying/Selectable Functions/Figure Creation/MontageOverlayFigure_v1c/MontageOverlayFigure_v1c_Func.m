%=========================================================
% 
%=========================================================

function [MOF,err] = MontageOverlayFigure_v1c_Func(MOF,INPUT)

Status2('busy','Motage Overlay Figure',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
Name = INPUT.Name;
MSTRCT = INPUT.MSTRCT;
IMSCL = MOF.IMSCL;
MSCL = MOF.MSCL;
clear INPUT

%----------------------------------------------
% Test
%----------------------------------------------
sz = size(Image);
if length(sz) == 3
    err.flag = 1;
    err.msg = 'Two images are necessary for an overlay';
    return
end
if sz(4) == 4
    Im1 = squeeze(Image(:,:,:,1:3));
    Im2 = squeeze(Image(:,:,:,4));
elseif sz(4) == 2
    Im1 = squeeze(Image(:,:,:,1));
    Im2 = squeeze(Image(:,:,:,2));
else
    Im1 = squeeze(Image(:,:,:,1));
    Im2 = squeeze(Image(:,:,:,end));
end

%----------------------------------------------
% Scale Map
%----------------------------------------------
func = str2func([MOF.mapscalefunc,'_Func']);  
INPUT.Image = Im2;
INPUT.MSTRCT = MSTRCT;
[MSCL,err] = func(MSCL,INPUT);
if err.flag
    return
end
clear INPUT;
Im2 = MSCL.Image;
MSTRCT0 = MSCL.MSTRCT;
MSTRCT.dispwid2 = MSTRCT0.dispwid;
MSTRCT.type2 = MSTRCT0.type;
if isfield(MSTRCT0,'zero')
    MSTRCT.zero2 = MSTRCT0.zero;
else
    MSTRCT.zero2 = 'colour';
end
if isfield(MSTRCT0,'useimagecolour')
    sz = size(Im2);
    if length(sz) ~= 4
        err.flag = 1;
        err.msg = 'The overlay image is not a true-colour image';
        return
    end
    MSTRCT.useimagecolour2 = MSTRCT0.useimagecolour;
else
    MSTRCT.useimagecolour2 = 'No';
end
if isfield(MSTRCT0,'colour')
    MSTRCT.colour2 = MSTRCT0.colour;
else
    MSTRCT.colour2 = 'No';
end

%----------------------------------------------
% Scale Base
%----------------------------------------------
func = str2func([MOF.imscalefunc,'_Func']);  
INPUT.Image = Im1;
INPUT.MSTRCT = MSTRCT;
[IMSCL,err] = func(IMSCL,INPUT);
if err.flag
    return
end
clear INPUT;
Im1 = IMSCL.Image;
MSTRCT0 = IMSCL.MSTRCT;
MSTRCT.dispwid1 = MSTRCT0.dispwid;
MSTRCT.type1 = MSTRCT0.type;
if isfield(MSTRCT0,'useimagecolour')
    sz = size(Im1);
    if length(sz) ~= 4
        err.flag = 1;
        err.msg = 'The base image is not a true-colour image';
        return
    end
    MSTRCT.useimagecolour1 = MSTRCT0.useimagecolour;
else
    MSTRCT.useimagecolour1 = 'No';
end
if isfield(MSTRCT0,'colour')
    MSTRCT.colour1 = MSTRCT0.colour;
else
    MSTRCT.colour1 = 'No';
end

%---------------------------------------------
% Create New Axis
%---------------------------------------------
MSTRCT.fhand = figure;
if strcmp(MOF.visible,'No')
    MSTRCT.fhand.Visible = 'off';
end
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
    sz = size(Image);
    num = length(MSTRCT.start:MSTRCT.step:MSTRCT.stop);
    for ncolumns = 1:20
        rows = ceil(num/ncolumns);
        horz = ncolumns*sz(2);
        vert = rows*sz(1);
        ratio(ncolumns) = horz/vert;
    end
    MSTRCT.ncolumns = find(ratio <= Ratio0,1,'last');    
end

%---------------------------------------------
% Other
%---------------------------------------------
MSTRCT.intensity = MOF.opacity;
MSTRCT.slclbl = MOF.slclbl;
MSTRCT.scale = MOF.scale;

%---------------------------------------------
% Image
%---------------------------------------------
INPUT.MSTRCT = MSTRCT;
INPUT.Image = cat(4,Im1,Im2);
[FIGDATA,err] = PlotMontageOverlay_v1e(INPUT);
MSTRCT.fhand.Name = Name;
MSTRCT.fhand.NumberTitle = 'off';

%---------------------------------------------
% Return for Save
%---------------------------------------------
fig = 1;
if contains(Name,'.mat')
    Name = Name(1:end-4);
end
MOF.Figure(fig).Name = Name;
MOF.Figure(fig).Type = 'Image';
MOF.Figure(fig).hFig = MSTRCT.fhand;
MOF.Figure(fig).hAx = MSTRCT.ahand;

Status2('done','',2);
Status2('done','',3);
