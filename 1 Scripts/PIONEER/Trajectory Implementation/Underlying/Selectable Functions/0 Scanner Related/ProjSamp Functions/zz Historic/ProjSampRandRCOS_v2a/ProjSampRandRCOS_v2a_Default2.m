%=========================================================
% 
%=========================================================

function [default] = ProjSampRandRCOS_v2a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RCOS';
default{m,1}.entrystr = '2.5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinRelDistTot';
default{m,1}.entrystr = '0.8';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinRelDistImp';
default{m,1}.entrystr = '1.0';