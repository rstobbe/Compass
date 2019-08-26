%=========================================================
% 
%=========================================================

function [default] = ImageSliceExtract_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Orientation';
default{m,1}.entrystr = 'Axial';
default{m,1}.options = {'Sagittal','Coronal','Axial'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Slice';
default{m,1}.entrystr = '1';
