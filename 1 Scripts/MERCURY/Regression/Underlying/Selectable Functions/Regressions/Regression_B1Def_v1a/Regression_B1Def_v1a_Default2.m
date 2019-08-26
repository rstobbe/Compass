%=========================================================
% 
%=========================================================

function [default] = Regression_B1Def_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    modpath = [SCRPTPATHS.mercuryloc,'Compass\Underlying\Selectable Functions\Model Testing'];
elseif strcmp(filesep,'/')
end
modfunc = 'ModTest_2CompRqiJ0_v1a';

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'B1DefFile_Excel';
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
default{m,1}.labelstr = 'ModTestfunc';
default{m,1}.entrystr = modfunc;
default{m,1}.searchpath = modpath;
default{m,1}.path = [modpath,modfunc];