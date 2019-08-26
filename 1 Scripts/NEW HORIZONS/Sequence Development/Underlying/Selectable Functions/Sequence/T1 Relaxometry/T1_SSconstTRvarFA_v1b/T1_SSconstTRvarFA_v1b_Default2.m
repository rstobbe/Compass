%=========================================================
% 
%=========================================================

function [default] = T1_SSconstTRvarFA_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Design_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TR (ms)';
default{m,1}.entrystr = '2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FlipArray (ms)';
default{m,1}.entrystr = '5,10,20';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T1_test (ms)';
default{m,1}.entrystr = '1330';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Design';
default{m,1}.labelstr = 'Design';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';