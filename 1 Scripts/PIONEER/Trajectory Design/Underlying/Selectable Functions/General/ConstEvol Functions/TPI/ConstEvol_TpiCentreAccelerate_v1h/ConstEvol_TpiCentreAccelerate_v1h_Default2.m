%=========================================================
% 
%=========================================================

function [default] = ConstEvol_TpiCentreAccelerate_v1h_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GaccStart';
default{m,1}.entrystr = '12000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GvelStart';
default{m,1}.entrystr = '180';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GaccTransition';
default{m,1}.entrystr = '4200';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GvelReturn';
default{m,1}.entrystr = '130';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ReturnTwk1';
default{m,1}.entrystr = '0.999650';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ReturnTwk2';
default{m,1}.entrystr = '0.999450';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FracDecel';
default{m,1}.entrystr = '0.100';