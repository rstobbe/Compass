%=========================================================
% 
%=========================================================

function [PLOT,err] = PlotMontageStandard_v1d_Func(PLOT,INPUT)

Status2('busy','Plot Montage',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
Name = INPUT.Name;
MSTRCT = INPUT.MSTRCT;
clear INPUT

%---------------------------------------------
% Create New Axis
%---------------------------------------------
MSTRCT.fhand = figure;
MSTRCT.ahand = axes('parent',MSTRCT.fhand);
MSTRCT.ahand.Position = [0,0,1,1];

%---------------------------------------------
% Colour
%---------------------------------------------
MSTRCT.colour = 'No';

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
% Image
%---------------------------------------------
INPUT.MSTRCT = MSTRCT;
INPUT.Image = Image;
[FIGDATA,err] = PlotMontageImage_v1e(INPUT);
FIGDATA.handles.fhand.Name = Name;
FIGDATA.handles.fhand.NumberTitle = 'off';

%---------------------------------------------
% Return
%---------------------------------------------
PLOT.handles = FIGDATA.handles;

Status2('done','',3);
