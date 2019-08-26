%=========================================================
% 
%=========================================================

function [default] = MpRageAnlzSiemens_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TR (ms)';
default{m,1}.entrystr = '2200';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TI (ms)';
default{m,1}.entrystr = '900';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelativeEcho (%)';
default{m,1}.entrystr = '37';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TurboFactor';
default{m,1}.entrystr = '224';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'EchoSpace (ms)';
default{m,1}.entrystr = '7.3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Flip (deg)';
default{m,1}.entrystr = '8';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'BW (Hz/Pix)';
default{m,1}.entrystr = '250';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TE (ms)';
default{m,1}.entrystr = '2.48';