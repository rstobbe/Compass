%=========================================================
% 
%=========================================================

function [default] = CreateDesImpTF_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    tfpath = [SCRPTPATHS.pioneerloc,'Analysis\Underlying\Selectable Functions\Trajectory Analysis\TF Build Functions\'];
elseif strcmp(filesep,'/')
end
tffunc = 'TFBuild_TPIimp_v1b';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'TF_Name';
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
default{m,1}.labelstr = 'TFBuildfunc';
default{m,1}.entrystr = tffunc;
default{m,1}.searchpath = tfpath;
default{m,1}.path = [tfpath,tffunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Calc';
default{m,1}.labelstr = 'Calc';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Calc';
