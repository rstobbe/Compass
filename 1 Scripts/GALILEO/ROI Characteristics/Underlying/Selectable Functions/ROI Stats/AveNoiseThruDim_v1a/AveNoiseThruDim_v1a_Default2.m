%=========================================================
% 
%=========================================================

function [default] = AveNoiseThruDim_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Distribution';
default{m,1}.entrystr = 'Rayleigh';
default{m,1}.options = {'Rayleigh','Normal'};