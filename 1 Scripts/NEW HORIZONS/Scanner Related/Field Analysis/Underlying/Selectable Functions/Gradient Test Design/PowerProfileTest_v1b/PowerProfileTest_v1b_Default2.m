%====================================================
%
%====================================================

function [default] = PowerProfileTest_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'NumTests';
default{m,1}.entrystr = '20';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PreDur (ms)';
default{m,1}.entrystr = '4';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RewindDur (ms)';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ReadDur (ms)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ReadGrad (mT/m)';
default{m,1}.entrystr = '5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GStepDur (us)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gsl (mT/m/ms)';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Dir';
default{m,1}.entrystr = 'Y';
default{m,1}.options = {'Z','Y','X'};

