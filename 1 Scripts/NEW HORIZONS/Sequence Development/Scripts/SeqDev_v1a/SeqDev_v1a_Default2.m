%=========================================================
% 
%=========================================================

function [default] = SeqDev_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    nmrpath = [SCRPTPATHS.newhorizonsloc,'Sequence Development\Underlying\Selectable Functions\NMR Parameters\Brain\GreyWhiteT1_v1a\'];
    Testpath = [SCRPTPATHS.newhorizonsloc,'Sequence Development\Underlying\Selectable Functions\Sequence\T1 Contrast\'];
elseif strcmp(filesep,'/')
end
nmrfunc = 'GreyWhiteT1_v1a';
Testfunc = 'MpRageAnlzSiemens_v1a';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Study_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Nmrfunc';
default{m,1}.entrystr = nmrfunc;
default{m,1}.searchpath = nmrpath;
default{m,1}.path = [nmrpath,nmrfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Seqfunc';
default{m,1}.entrystr = Testfunc;
default{m,1}.searchpath = Testpath;
default{m,1}.path = [Testpath,Testfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Design';
default{m,1}.labelstr = 'Design';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';