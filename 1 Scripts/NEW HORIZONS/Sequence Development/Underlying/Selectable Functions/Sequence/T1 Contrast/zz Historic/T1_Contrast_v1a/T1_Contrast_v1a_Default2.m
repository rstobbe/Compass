%=========================================================
% 
%=========================================================

function [default] = T1_Contrast_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    Testpath = [SCRPTPATHS.newhorizonsloc,'Study Design\T1 Contrast\Underlying\Selectable Functions\'];
elseif strcmp(filesep,'/')
end
Testfunc = 'T1_CNRopt_v1b';

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
default{m,1}.labelstr = 'T1_tissue1 (ms)';
default{m,1}.entrystr = '1330';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T1_tissue2 (ms)';
default{m,1}.entrystr = '830';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Testfunc';
default{m,1}.entrystr = Testfunc;
default{m,1}.searchpath = Testpath;
default{m,1}.path = [Testpath,Testfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Design';
default{m,1}.labelstr = 'Design';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';