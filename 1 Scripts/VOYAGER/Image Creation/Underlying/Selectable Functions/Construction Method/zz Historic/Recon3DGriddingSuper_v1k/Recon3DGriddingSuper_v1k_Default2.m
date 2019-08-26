%=========================================================
% 
%=========================================================

function [default] = Recon3DGriddingSuper_v1k_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Test';
default{m,1}.entrystr = 'None';
default{m,1}.options = {'1RcvrOnly','None'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Visuals';
default{m,1}.entrystr = 'SingleIm';
default{m,1}.options = {'SingleIm','NewSingleIm','MultiIm','No'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RxProfRes (mm)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RxProfFilt (beta)';
default{m,1}.entrystr = '12';

