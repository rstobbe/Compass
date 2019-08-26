%=========================================================
% 
%=========================================================

function [default] = B0MapSiemens_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'AbsThresh (rel)';
default{m,1}.entrystr = '0.2';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ShimCalPol';
default{m,1}.entrystr = 'B0';
default{m,1}.options = {'B0','AbsFreq'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'No','Yes'};
