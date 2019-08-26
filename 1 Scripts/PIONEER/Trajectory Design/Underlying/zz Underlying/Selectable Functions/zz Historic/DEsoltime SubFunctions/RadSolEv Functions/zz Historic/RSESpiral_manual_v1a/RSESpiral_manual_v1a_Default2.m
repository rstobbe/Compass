%=========================================================
% 
%=========================================================

function [default] = RSESpiral_manual_v1a_Default2(~)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RadPwr';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PLenInTol';
default{m,1}.entrystr = '1e-6';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PLenOutTol';
default{m,1}.entrystr = '1e-7';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SolInTol';
default{m,1}.entrystr = '1e-4';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SolOutTol';
default{m,1}.entrystr = '1e-8';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'D';
default{m,1}.entrystr = '3900';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SolInLenFact';
default{m,1}.entrystr = '1';