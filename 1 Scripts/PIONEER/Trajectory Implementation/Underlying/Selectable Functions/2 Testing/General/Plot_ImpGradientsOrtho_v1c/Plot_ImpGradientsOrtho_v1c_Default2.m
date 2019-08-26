%=========================================================
% 
%=========================================================

function [default] = Plot_ImpGradientsOrtho_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrajNum';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Crop';
default{m,1}.entrystr = 'FullTraj';
default{m,1}.options = {'CropReadout','FullTraj'};