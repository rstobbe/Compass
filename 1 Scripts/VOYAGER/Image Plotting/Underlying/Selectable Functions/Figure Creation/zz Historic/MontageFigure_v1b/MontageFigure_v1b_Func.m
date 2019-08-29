%=========================================================
% 
%=========================================================

function [MONT,err] = MontageFigure_v1b_Func(MONT,INPUT)

Status2('busy','Create Montage Figure',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
Name = INPUT.Name;
MSTRCT = INPUT.MSTRCT;
IMSCL = MONT.IMSCL;
clear INPUT

%----------------------------------------------
% Test (use 1nd image if from array)
%----------------------------------------------
sz = size(Image);
if length(sz) > 3
    Image = Image(:,:,:,1,1,1,1);
end

%----------------------------------------------
% Scale
%----------------------------------------------
func = str2func([MONT.imscalefunc,'_Func']);  
INPUT.Image = Image;
INPUT.MSTRCT = MSTRCT;
[IMSCL,err] = func(IMSCL,INPUT);
if err.flag
    return
end
clear INPUT;
Image = IMSCL.Image;
MSTRCT = IMSCL.MSTRCT;

%---------------------------------------------
% Create New Axis
%---------------------------------------------
MSTRCT.fhand = figure;
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

%----------------------------------------------
% Options
%----------------------------------------------
MSTRCT.colour = MONT.colour;
MSTRCT.slclbl = MONT.slclbl;
MSTRCT.scale = MONT.scale;

%---------------------------------------------
% Image
%---------------------------------------------
INPUT.MSTRCT = MSTRCT;
INPUT.Image = Image;
[FIGDATA,err] = PlotMontageImage_v1e(INPUT);
MSTRCT.fhand.Name = Name;
MSTRCT.fhand.NumberTitle = 'off';

%---------------------------------------------
% Return for Save
%---------------------------------------------
fig = 1;
if contains(Name,'.mat')
    Name = Name(1:end-4);
end
MONT.Figure(fig).Name = Name;
MONT.Figure(fig).Type = 'Image';
MONT.Figure(fig).hFig = MSTRCT.fhand;
MONT.Figure(fig).hAx = MSTRCT.ahand;


Status2('done','',2);
Status2('done','',3);
