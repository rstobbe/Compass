%=========================================================
% 
%=========================================================

function [default] = PlotMontage_v1c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    scalepath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\Selectable Functions\Image Scale\'];
elseif strcmp(filesep,'/')
end
scalefunc = 'ImScale_RelFullValue_v1a';
addpath([scalepath,scalefunc]);

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Type';
default{m,1}.entrystr = 'Abs';
default{m,1}.options = {'Real','Imag','Phase','Abs'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Orientation';
default{m,1}.entrystr = 'Axial';
default{m,1}.options = {'Sagittal','Coronal','Axial'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Rotation';
default{m,1}.entrystr = '0';
default{m,1}.options = {'90','0','-90'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Slices (a:b:c)';
default{m,1}.entrystr = '1:2:128';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Inset (A,P,L,R,T,B)';
default{m,1}.entrystr = '0,0,0,0,0,0';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImScalefunc';
default{m,1}.entrystr = scalefunc;
default{m,1}.searchpath = scalepath;
default{m,1}.path = [scalepath,scalefunc];

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Colour';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'nRows';
default{m,1}.entrystr = '8';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'imSize (v,h)';
default{m,1}.entrystr = '700,700';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'SliceLabel';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FigNo';
default{m,1}.entrystr = 'Continue';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'PlotImage';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';
