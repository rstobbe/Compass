%=========================================================
% 
%=========================================================

function [default] = Study_RelaxometryInputExcel_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    anlzpath = [SCRPTPATHS.apolloloc,'Simple Studies\Underlying\Selectable Functions\Relaxometry\'];
elseif strcmp(filesep,'/')
end
anlzfunc = 'Relax_T1BasicInvRec_v1a';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Study_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'ExcelFile';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectExcelFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.experimentsloc;
default{m,1}.runfunc2 = 'SelectExcelFileDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.experimentsloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;
 
m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Analysisfunc';
default{m,1}.entrystr = anlzfunc;
default{m,1}.searchpath = anlzpath;
default{m,1}.path = [anlzpath,anlzfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Anlz';
default{m,1}.labelstr = 'Anlz';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
