%=========================================================
% 
%=========================================================

function [default] = ConstEvol_TpiCentreAccelerate_v1j_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GaccStart';
default{m,1}.entrystr = '8000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GvelStart';
default{m,1}.entrystr = '170';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FracDecel';
default{m,1}.entrystr = '0.12';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GaccTransition';
default{m,1}.entrystr = '5000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GvelReturn';
default{m,1}.entrystr = '120';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ReturnTwk1';
default{m,1}.entrystr = '0.99970';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TwkLoc2';
default{m,1}.entrystr = '0.15';

