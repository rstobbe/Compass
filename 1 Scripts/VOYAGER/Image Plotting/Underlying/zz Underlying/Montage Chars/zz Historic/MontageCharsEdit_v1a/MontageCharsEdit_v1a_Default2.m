%=========================================================
% 
%=========================================================

function [default] = MontageCharsEdit_v1a_Default2(SCRPTPATHS)

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
default{m,1}.labelstr = 'Slices (a:b:c)';
default{m,1}.entrystr = '1:2:128';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Inset (A,P,L,R,T,B)';
default{m,1}.entrystr = '0,0,0,0,0,0';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'SliceLabel';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'No','Yes'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'nColumns';
default{m,1}.entrystr = '8';


