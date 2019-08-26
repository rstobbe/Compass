%=========================================================
% 
%=========================================================

function [default] = TurnSolution_Overshoot_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelativeOvershoot';
default{m,1}.entrystr = '1.00001';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TurnStart';
default{m,1}.entrystr = '0.85';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxRadDerivative';
default{m,1}.entrystr = '0.02';