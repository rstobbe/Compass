%=========================================================
% 
%=========================================================

function [default] = OrientFlexible_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'kxyz';
default{m,1}.entrystr = 'xyz';
default{m,1}.options = {'xyz','yxz','zxy','xzy','yzx','zyx'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ReconOrient';
default{m,1}.entrystr = 'Axial';
default{m,1}.options = {'Axial','Coronal','Sagittal'};



