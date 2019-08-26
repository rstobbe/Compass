%=========================================================
% 
%=========================================================

function [default] = Spin_KaiserShaped_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SampStart';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SampEnd';
default{m,1}.entrystr = '0.5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SampShift';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SampBeta';
default{m,1}.entrystr = '12';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CentreSpinFact';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SpawningFact';
default{m,1}.entrystr = '6';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SpiralOverShoot';
default{m,1}.entrystr = '0';