%=========================================================
% 
%=========================================================

function [default] = Test_Proj3D_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    testpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\2 Testing\General\'];
elseif strcmp(filesep,'/')
end
testfunc = 'Plot_ImpGradientsOrtho_v1c';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Test_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadTrajImpDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Testfunc';
default{m,1}.entrystr = testfunc;
default{m,1}.searchpath = testpath;
default{m,1}.path = [testpath,testfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Test';
default{m,1}.labelstr = 'Test';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';