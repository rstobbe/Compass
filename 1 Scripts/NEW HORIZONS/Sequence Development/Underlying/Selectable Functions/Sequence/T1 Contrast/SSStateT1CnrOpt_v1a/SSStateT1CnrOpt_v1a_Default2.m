%=========================================================
% 
%=========================================================

function [default] = SSStateT1CnrOpt_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'NonAcqTime (ms)';
default{m,1}.entrystr = '3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinTR (ms)';
default{m,1}.entrystr = '5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxTR (ms)';
default{m,1}.entrystr = '20';