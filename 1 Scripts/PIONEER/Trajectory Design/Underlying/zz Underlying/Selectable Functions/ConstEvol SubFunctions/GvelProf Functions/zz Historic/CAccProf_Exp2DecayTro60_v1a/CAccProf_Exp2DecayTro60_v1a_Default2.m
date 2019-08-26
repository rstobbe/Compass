%=========================================================
% 
%=========================================================

function [default] = CAccProf_Exp2DecayTro60_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'tau (%)';
default{m,1}.entrystr = '0.0004';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'startfrac (%)';
default{m,1}.entrystr = '135';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'decayrate';
default{m,1}.entrystr = '12';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'decayshift (%)';
default{m,1}.entrystr = '20';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'enddrop (%)';
default{m,1}.entrystr = '7';


