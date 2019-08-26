%=========================================================
% 
%=========================================================

function [default] = MonoExpRFpostGradWithOffset_v1d_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'SelectField';
default{m,1}.entrystr = 'GradField';
default{m,1}.options = {'B0Field','GradField'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'B0cal (1%->uTpG)';
default{m,1}.entrystr = '0.047';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gcal (%->sys%)';
default{m,1}.entrystr = '0.97';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DataStart (ms)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DataStop (ms)';
default{m,1}.entrystr = '20';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tc Estimate (ms)';
default{m,1}.entrystr = '1';
