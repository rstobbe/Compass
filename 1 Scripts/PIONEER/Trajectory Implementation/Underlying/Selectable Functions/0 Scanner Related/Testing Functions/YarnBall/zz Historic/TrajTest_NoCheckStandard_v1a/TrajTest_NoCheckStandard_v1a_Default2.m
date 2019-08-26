%=========================================================
% 
%=========================================================

function [default] = TrajTest_NoCheckStandard_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TestTraj';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Redraw';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};
