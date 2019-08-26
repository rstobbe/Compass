%=========================================================
% 
%=========================================================

function [default] = AddExpTransResp_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'StartFromZero';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'No','Yes'};