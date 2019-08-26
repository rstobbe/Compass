%=========================================================
% 
%=========================================================

function [default] = BrainMask1_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Dims (TB,LR,IO)';
default{m,1}.entrystr = '50,50,50';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Disp (TB,LR,IO)';
default{m,1}.entrystr = '0,0,0';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Orientation';
default{m,1}.entrystr = 'Axial';
default{m,1}.options = {'Sagittal','Coronal','Axial'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Inset (T,B,L,R,I,O)';
default{m,1}.entrystr = '0,0,0,0,0,0';

