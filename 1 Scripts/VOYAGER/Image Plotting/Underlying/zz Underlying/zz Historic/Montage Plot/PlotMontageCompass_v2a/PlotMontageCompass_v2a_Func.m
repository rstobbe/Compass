%=========================================================
% 
%=========================================================

function [PLOT,err] = PlotMontageCompass_v2a_Func(PLOT,INPUT)

Status2('busy','Plot Montage',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
MSTRCT = INPUT.MSTRCT;
clear INPUT

%---------------------------------------------
% Columns
%---------------------------------------------
if not(isfield(MSTRCT,'ncolumns'))
    MSTRCT.ncolumns = [];
end
if isempty(MSTRCT.ncolumns)
    Ratio0 = 1.5;
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
% Create Montage Matrix
%--------------------------------------------- 
[Image,slcelab] = CreateMontageImageArray_v1b(Image,MSTRCT);

%---------------------------------------------
% Plot
%--------------------------------------------- 
INPUT.Image = Image;
INPUT.MSTRCT = MSTRCT;
IMDISP = ImagingPlotSetup(INPUT);

%---------------------------------------------
% Return
%---------------------------------------------
PLOT.Im = Image;
PLOT.MSTRCT = MSTRCT;
PLOT.IMDISP = IMDISP;
PLOT.CompassDisplay = 'Yes';

Status2('done','',3);
