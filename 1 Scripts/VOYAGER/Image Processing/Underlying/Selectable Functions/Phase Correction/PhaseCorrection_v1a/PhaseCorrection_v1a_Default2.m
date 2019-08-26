%=========================================================
% 
%=========================================================

function [default] = PhaseCorrection_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PhaseRes (mm)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PhaseFilt (beta)';
default{m,1}.entrystr = '12';
