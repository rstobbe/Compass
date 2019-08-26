%=========================================================
% 
%=========================================================

function [default] = Model_GradSysResponse_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    Modelpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\System Response Modeling\'];
elseif strcmp(filesep,'/')
end
Modelfunc = 'FirSysModelRegress_v1a';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Model_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'FieldEvo_File';
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
default{m,1}.labelstr = 'Modelfunc';
default{m,1}.entrystr = Modelfunc;
default{m,1}.searchpath = Modelpath;
default{m,1}.path = [Modelpath,Modelfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Model';
default{m,1}.labelstr = 'Model';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';