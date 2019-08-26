%=========================================================
% 
%=========================================================

function [default] = SodiumRegression_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    regpath = [SCRPTPATHS.mercuryloc,'Regression\Underlying\Selectable Functions\Regressions'];
    exppath = [SCRPTPATHS.mercuryloc,'Regression\Underlying\Selectable Functions\Setup'];
elseif strcmp(filesep,'/')
end
regfunc = 'Regression_Standard_v1a';
expfunc = 'BuildExp_ExcelFile_v1a';

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
default{m,1}.labelstr = 'DataFile_Excel';
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
default{m,1}.labelstr = 'BuildExpfunc';
default{m,1}.entrystr = expfunc;
default{m,1}.searchpath = exppath;
default{m,1}.path = [exppath,expfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Regressionfunc';
default{m,1}.entrystr = regfunc;
default{m,1}.searchpath = regpath;
default{m,1}.path = [regpath,regfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'reg';
default{m,1}.labelstr = 'Anlz';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
