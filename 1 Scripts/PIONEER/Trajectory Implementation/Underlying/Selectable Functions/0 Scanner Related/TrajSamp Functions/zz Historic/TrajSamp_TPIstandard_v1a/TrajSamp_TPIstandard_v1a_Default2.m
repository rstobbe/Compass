%=========================================================
% 
%=========================================================

function [default] = TrajSamp_TPIstandard_v1a_Default2(SCRPTPATHS)

OverSamp_Des = 1.2;
RelBW_Des = 1.1;
StartFrac_Des = 0.6;

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'OverSamp_Des';
default{m,1}.entrystr = OverSamp_Des;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelBW_Des';
default{m,1}.entrystr = RelBW_Des;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'StartFrac_Des';
default{m,1}.entrystr = StartFrac_Des;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Match_Iseg';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};