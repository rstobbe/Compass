%====================================================
%
%====================================================

function [default] = Create_RFwfm_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    simpath = [SCRPTPATHS.newhorizonsloc,'\Scanner Related\RF Waveforms\Underlying\Simulate\'];
    wrtpath = [SCRPTPATHS.newhorizonsloc,'\Scanner Related\RF Waveforms\Underlying\Write\'];
elseif strcmp(filesep,'/')
end
simfunc = 'Sim_RFwfm_v1a';
addpath([simpath,simfunc]);
wrtfunc = 'Write_RFwfm_v1a';
addpath([wrtpath,wrtfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RF_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SlvPts';
default{m,1}.entrystr = '128';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'WfmPts';
default{m,1}.entrystr = '1000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TimeBWprod';
default{m,1}.entrystr = '5.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RippleIn';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RippleOut';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Flip';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'RFtype';
default{m,1}.entrystr = 'Ex';
default{m,1}.options = {'Ex','Ref','Inv','MinPh','MaxPh'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Simfunc';
default{m,1}.entrystr = simfunc;
default{m,1}.searchpath = simpath;
default{m,1}.path = [simpath,simfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Wrtfunc';
default{m,1}.entrystr = wrtfunc;
default{m,1}.searchpath = wrtpath;
default{m,1}.path = [wrtpath,wrtfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'CreateRF';
default{m,1}.labelstr = 'Create RF';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

