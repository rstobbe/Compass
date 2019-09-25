%=========================================================
% 
%=========================================================

function [default] = AlignMultiImagesToFirst_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Config';
default{m,1}.entrystr = 'monomodal';
default{m,1}.options = {'monomodal','multimodal'};
