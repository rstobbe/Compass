%=========================================================
% 
%=========================================================

function [default] = Regression_Standard_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    modpath = [SCRPTPATHS.mercuryloc,'Compass\Underlying\Selectable Functions\Model Testing'];
elseif strcmp(filesep,'/')
end
modfunc = 'ModTest_2CompRqiJ0_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ModTestfunc';
default{m,1}.entrystr = modfunc;
default{m,1}.searchpath = modpath;
default{m,1}.path = [modpath,modfunc];