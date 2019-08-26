%=========================================================
% 
%=========================================================

function [default] = pCASL_Tagging_v1e_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    simpath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\zz Underlying\Selectable Functions\Bloch Equations\'];
elseif strcmp(filesep,'/')
end
simfunc = 'StandardBloch_v1a';
addpath([simpath,simfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RF_FA (deg)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RF_tau (ms)';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'RF_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'SelectGeneralFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'No';
default{m,1}.runfunc2 = 'SelectGeneralFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'No';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DutyCycle (%)';
default{m,1}.entrystr = '20';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExciteWid (m)';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SimulationWid (m)';
default{m,1}.entrystr = '0.12';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SSaref';
default{m,1}.entrystr = '0.5';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'TagControl';
default{m,1}.entrystr = 'Tag';
default{m,1}.options = {'Tag','Control'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Simfunc';
default{m,1}.entrystr = simfunc;
default{m,1}.searchpath = simpath;
default{m,1}.path = [simpath,simfunc];

