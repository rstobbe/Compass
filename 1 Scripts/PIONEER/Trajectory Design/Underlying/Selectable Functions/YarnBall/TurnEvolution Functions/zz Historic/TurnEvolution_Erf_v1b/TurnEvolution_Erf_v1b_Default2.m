%=========================================================
% 
%=========================================================

function [default] = TurnEvolution_Erf_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Start';
default{m,1}.entrystr = '1.9';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Slope';
default{m,1}.entrystr = '40';