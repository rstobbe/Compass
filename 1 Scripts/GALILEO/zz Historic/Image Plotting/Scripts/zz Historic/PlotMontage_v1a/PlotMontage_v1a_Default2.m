%=========================================================
% 
%=========================================================

function [default] = PlotMontage_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'leftinset';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'rightinset';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'bottominset';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'topinset';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'zstart';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'zstop';
default{m,1}.entrystr = '120';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'zstep';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'nrows';
default{m,1}.entrystr = '2';

