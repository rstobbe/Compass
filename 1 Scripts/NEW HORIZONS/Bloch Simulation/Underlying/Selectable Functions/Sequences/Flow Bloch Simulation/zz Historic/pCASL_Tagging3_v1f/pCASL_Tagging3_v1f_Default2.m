%=========================================================
% 
%=========================================================

function [default] = pCASL_Tagging2_v1f_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    simpath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\zz Underlying\Selectable Functions\Bloch Equations\'];
elseif strcmp(filesep,'/')
end
simfunc = 'StandardBloch_v1a';
addpath([simpath,simfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RF_FA (deg)';
default{m,1}.entrystr = '35';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RF_tau (ms)';
default{m,1}.entrystr = '0.5';

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
default{m,1}.entrystr = '25';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gss (mT/m)';
default{m,1}.entrystr = '6';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gave (mT/m)';
default{m,1}.entrystr = '0.39';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SimulationWid (m)';
default{m,1}.entrystr = '0.07';

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

