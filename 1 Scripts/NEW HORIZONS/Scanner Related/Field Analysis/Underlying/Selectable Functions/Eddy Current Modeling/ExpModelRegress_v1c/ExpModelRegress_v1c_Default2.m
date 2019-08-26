%=========================================================
% 
%=========================================================

function [default] = ExpModelRegress_v1c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    atrpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Add Transient Response\'];
elseif strcmp(filesep,'/')
end
atrfunc = 'AddExpTransResp_v1a';
addpath([atrpath,atrfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tc Estimate (ms)';
default{m,1}.entrystr = '0.06';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Mag Estimate (%)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ATRfunc';
default{m,1}.entrystr = atrfunc;
default{m,1}.searchpath = atrpath;
default{m,1}.path = [atrpath,atrfunc];

