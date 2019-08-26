%=========================================================
% 
%=========================================================

function [default] = SysModelRegress_v1e_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    atrpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Add Transient Response\'];
elseif strcmp(filesep,'/')
end
atrfunc = 'AddDecayingExpTransResp_v1b';
addpath([atrpath,atrfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SubRrgsLen (ms)';
default{m,1}.entrystr = 'full';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tc Estimate (ms)';
default{m,1}.entrystr = '0.06';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Mag Estimate (%)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gdel Estimate (us)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GradStart (ms)';
default{m,1}.entrystr = '0.5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DecayingEst (ms)';
default{m,1}.entrystr = '0.005';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ATRfunc';
default{m,1}.entrystr = atrfunc;
default{m,1}.searchpath = atrpath;
default{m,1}.path = [atrpath,atrfunc];

