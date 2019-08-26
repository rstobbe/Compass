%=========================================================
% 
%=========================================================

function [default] = OneDimMask_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Width (mm)';
default{m,1}.entrystr = '120';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Displace (mm)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Direction';
default{m,1}.entrystr = 'IO';
default{m,1}.options = {'IO','LR','TB'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Plot Orient';
default{m,1}.entrystr = 'Sagittal';
default{m,1}.options = {'Sagittal','Coronal','Axial'};

