%=========================================================
% 
%=========================================================

function [default] = CalcSDC_ConstDefAcc_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxRelChange';
default{m,1}.entrystr = '2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Acc';
default{m,1}.entrystr = '1';