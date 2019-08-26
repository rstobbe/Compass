%====================================================
%
%====================================================

function [default] = Create_RFwfm_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    crtepath = [SCRPTPATHS.newhorizonsloc,'\Scanner Related\RF Waveforms\Underlying\Create\'];
    simpath = [SCRPTPATHS.newhorizonsloc,'\Scanner Related\RF Waveforms\Underlying\Simulate\'];
    wrtpath = [SCRPTPATHS.newhorizonsloc,'\Scanner Related\RF Waveforms\Underlying\Write\'];
    calcpath = [SCRPTPATHS.newhorizonsloc,'\Scanner Related\RF Waveforms\Underlying\Analyze\'];
elseif strcmp(filesep,'/')
end
crtefunc = 'Create_exSLR_v1a';
simfunc = 'Sim_RFwfm_v1a';
calcfunc = 'Calc_exSLR_v1a';
wrtfunc = 'Write_RFwfmV_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RF_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Createfunc';
default{m,1}.entrystr = crtefunc;
default{m,1}.searchpath = crtepath;
default{m,1}.path = [crtepath,crtefunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Simfunc';
default{m,1}.entrystr = simfunc;
default{m,1}.searchpath = simpath;
default{m,1}.path = [simpath,simfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Calcfunc';
default{m,1}.entrystr = calcfunc;
default{m,1}.searchpath = calcpath;
default{m,1}.path = [calcpath,calcfunc];

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

