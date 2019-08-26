%=========================================================
% 
%=========================================================

function [default] = SeqSimContSatTest_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    simpath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\zz Underlying\Selectable Functions\Bloch Equations\'];
elseif strcmp(filesep,'/')
end
simfunc = 'StandardBloch_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RF_FA (deg)';
default{m,1}.entrystr = '10000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RF_woff (Hz)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RF_tau (ms)';
default{m,1}.entrystr = '1000';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Simfunc';
default{m,1}.entrystr = simfunc;
default{m,1}.searchpath = simpath;
default{m,1}.path = [simpath,simfunc];

