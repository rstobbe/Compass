%=========================================================
% 
%=========================================================

function [default] = MontageCharsImMultiArrEdit_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Orientation';
default{m,1}.entrystr = 'Axial';
default{m,1}.options = {'Sagittal','Coronal','Axial'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Index';
default{m,1}.entrystr = ':,:,:,1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Inset (A,P,L,R,T,B)';
default{m,1}.entrystr = '0,0,0,0,0,0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'nColumns';
default{m,1}.entrystr = '8';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Normalize';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'Each_Image','Global','Off'};