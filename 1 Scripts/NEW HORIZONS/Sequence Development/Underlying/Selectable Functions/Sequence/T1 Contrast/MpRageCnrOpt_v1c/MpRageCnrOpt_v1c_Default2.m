%=========================================================
% 
%=========================================================

function [default] = MpRageCnrOpt_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'NonAcqTime (ms)';
default{m,1}.entrystr = '3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TiDelMin (ms)';
default{m,1}.entrystr = '20';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrDel (ms)';
default{m,1}.entrystr = '20';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Slices';
default{m,1}.entrystr = '256';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinTR (ms)';
default{m,1}.entrystr = '5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxTR (ms)';
default{m,1}.entrystr = '20';

