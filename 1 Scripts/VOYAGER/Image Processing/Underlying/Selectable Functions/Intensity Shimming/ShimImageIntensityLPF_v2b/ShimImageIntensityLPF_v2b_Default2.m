%=========================================================
% 
%=========================================================

function [default] = ShimImageIntensityLPF_v2b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ImProfRes (mm)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ImProfFilt (beta)';
default{m,1}.entrystr = '12';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ProfStrch (mm)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ProfRelMin';
default{m,1}.entrystr = '0.35';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'BGdisp';
default{m,1}.entrystr = 'ProfRelMin';
default{m,1}.options = {'ProfRelMin','NaN'};