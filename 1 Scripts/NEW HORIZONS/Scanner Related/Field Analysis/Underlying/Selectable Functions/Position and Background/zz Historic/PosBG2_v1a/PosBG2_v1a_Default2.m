%====================================================
%
%====================================================

function [default] = PosBG2_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'NoGrad Vis';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'Off','Partial','Full'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'PosLoc Vis';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'Off','Partial','Full'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PLstart (ms)';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PLstop (ms)';
default{m,1}.entrystr = '1.3';





