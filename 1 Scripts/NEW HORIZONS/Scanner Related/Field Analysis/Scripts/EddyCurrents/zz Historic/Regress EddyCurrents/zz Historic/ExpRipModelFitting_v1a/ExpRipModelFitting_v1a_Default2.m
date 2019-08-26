%=========================================================
% 
%=========================================================

function [default] = ExpRipModelFitting_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    modelpath = [SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Eddy Current Modeling\'];
elseif strcmp(filesep,'/')
end
modelfunc = 'ExpRipModelRegress_v1a';
addpath([modelpath,modelfunc]);

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Rgrs_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'GradDes_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

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
default{m,1}.labelstr = 'SincFreq Est (kHz)';
default{m,1}.entrystr = '4';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SincTc Est (ms)';
default{m,1}.entrystr = '0.06';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SincMag Est (%)';
default{m,1}.entrystr = '50';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpTc Est (ms)';
default{m,1}.entrystr = '0.06';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExpMag Est (%)';
default{m,1}.entrystr = '15';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Regression';
default{m,1}.labelstr = 'Regression';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

