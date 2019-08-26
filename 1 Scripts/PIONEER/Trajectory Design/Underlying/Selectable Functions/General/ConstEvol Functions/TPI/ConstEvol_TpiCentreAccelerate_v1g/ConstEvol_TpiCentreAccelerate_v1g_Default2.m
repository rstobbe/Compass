%=========================================================
% 
%=========================================================

function [default] = ConstEvol_TpiCentreAccelerate_v1g_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GaccStart';
default{m,1}.entrystr = '8000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GvelStart';
default{m,1}.entrystr = '180';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GaccTransition';
default{m,1}.entrystr = '4000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GvelReturn';
default{m,1}.entrystr = '150';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GaccReturn';
default{m,1}.entrystr = '2000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FracDecel';
default{m,1}.entrystr = '0.125';