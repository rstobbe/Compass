%=========================================================
% 
%=========================================================

function [default] = TrajModelFitting_v1f_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    modelpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Eddy Current Modeling\'];
elseif strcmp(filesep,'/')
end
modelfunc = 'SysModelRegress_v1c';
addpath([modelpath,modelfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Rgrs_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Data_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

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
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrajNum';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrajOrtho';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Polarity';
default{m,1}.entrystr = 'Pos';
default{m,1}.options = {'Pos','Neg'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Modelfunc';
default{m,1}.entrystr = modelfunc;
default{m,1}.searchpath = modelpath;
default{m,1}.path = [modelpath,modelfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Regression';
default{m,1}.labelstr = 'Regression';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

