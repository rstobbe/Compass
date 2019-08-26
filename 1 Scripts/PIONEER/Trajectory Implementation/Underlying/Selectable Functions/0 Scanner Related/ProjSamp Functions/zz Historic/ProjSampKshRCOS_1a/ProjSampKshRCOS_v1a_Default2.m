%=========================================================
% 
%=========================================================

function [default] = ProjSampRandKshRCOS_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'StdevTheta(fracOS)';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'StdevPhi(deg)';
default{m,1}.entrystr = '2.0';