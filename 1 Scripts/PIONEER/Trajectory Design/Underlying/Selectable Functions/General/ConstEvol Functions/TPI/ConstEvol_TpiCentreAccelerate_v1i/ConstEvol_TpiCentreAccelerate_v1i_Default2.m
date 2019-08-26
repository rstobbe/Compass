%=========================================================
% 
%=========================================================

function [default] = ConstEvol_TpiCentreAccelerate_v1i_Default2(SCRPTPATHS)

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
default{m,1}.entrystr = '4700';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GvelReturn';
default{m,1}.entrystr = '125';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ReturnTwk1';
default{m,1}.entrystr = '0.999740';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ReturnTwk2';
default{m,1}.entrystr = '0.999380';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TwkLoc2';
default{m,1}.entrystr = '0.15';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FracDecel';
default{m,1}.entrystr = '0.100';