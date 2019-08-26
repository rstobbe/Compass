%=========================================================
% 
%=========================================================

function [default] = TrajSamp_SiemensLR_v3g_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinBaseOverSamp';
default{m,1}.entrystr = '1.2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SysOverSamp';
default{m,1}.entrystr = '1.25';

