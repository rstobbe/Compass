%=========================================================
% 
%=========================================================

function [default] = Regress_EddyCurrents_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    Regresspath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Eddy Current Regression\'];
elseif strcmp(filesep,'/')
end
Regressfunc = 'MonoExpRFpostGrad_v1d';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'EddyRegress_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'EddyCurrent_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadScriptFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadScriptFileDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'EddyRegressfunc';
default{m,1}.entrystr = Regressfunc;
default{m,1}.searchpath = Regresspath;
default{m,1}.path = [Regresspath,Regressfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Regress';
default{m,1}.labelstr = 'Eddy Regress';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';