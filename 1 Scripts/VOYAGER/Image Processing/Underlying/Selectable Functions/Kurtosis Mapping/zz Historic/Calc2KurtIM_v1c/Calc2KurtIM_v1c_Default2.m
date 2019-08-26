%=========================================================
% 
%=========================================================

function [default] = Calc2KurtIM_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Constrain';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'No','Yes'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinVal_b0';
default{m,1}.entrystr = '60';



