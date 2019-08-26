%=========================================================
% 
%=========================================================

function [default] = TrajModelFitting_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    modelpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Eddy Current Modeling\'];
elseif strcmp(filesep,'/')
end
modelfunc = 'ExpModelRegress_v1a';
addpath([modelpath,modelfunc]);

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Rgrs_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'No';
default{m,1}.runfunc2 = 'LoadTrajImpDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'No';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Modelfunc';
default{m,1}.entrystr = modelfunc;
default{m,1}.searchpath = modelpath;
default{m,1}.path = [modelpath,modelfunc];

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GStartShift (us)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tc Estimate (ms)';
default{m,1}.entrystr = '0.06';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Mag Estimate (%)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Regression';
default{m,1}.labelstr = 'Regression';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

