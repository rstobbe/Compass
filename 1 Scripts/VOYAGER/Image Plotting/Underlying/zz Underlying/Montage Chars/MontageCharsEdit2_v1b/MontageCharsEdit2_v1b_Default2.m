%=========================================================
% 
%=========================================================

function [default] = MontageCharsEdit2_v1b_Default2(SCRPTPATHS)

m = 1;
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
default{m,1}.labelstr = 'NumSlices';
default{m,1}.entrystr = '30';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Inset (A,P,L,R,I,O)';
default{m,1}.entrystr = '0,0,0,0,0,0';



