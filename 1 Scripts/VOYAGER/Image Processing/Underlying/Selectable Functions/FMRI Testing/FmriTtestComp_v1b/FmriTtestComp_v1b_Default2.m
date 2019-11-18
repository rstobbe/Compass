%=========================================================
% 
%=========================================================

function [default] = FmriTtestComp_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Paradigm_ExcelFile';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectExcelFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.experimentsloc;
default{m,1}.runfunc2 = 'SelectExcelFileDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.experimentsloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinSigVal';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RefSigVal';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Significance';
default{m,1}.entrystr = '0.05';