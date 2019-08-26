%=========================================================
% 
%=========================================================

function [default] = CAccProf_Exp2Decay2_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'tau (%)';
default{m,1}.entrystr = '0.0025';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'startfrac (%)';
default{m,1}.entrystr = '120';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'decayrate';
default{m,1}.entrystr = '20';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'decayshift (%)';
default{m,1}.entrystr = '30';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'enddrop (%)';
default{m,1}.entrystr = '10';


