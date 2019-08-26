%=========================================================
% 
%=========================================================

function [default] = IdeaWfmTestWrt_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    wrtsyspath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\WrtSys Functions\'];
    trajorderpath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\TrajOrder Functions\'];
elseif strcmp(filesep,'/')
end
wrtsysfunc = 'WrtSys_SiemensYarnBall_v2e';
trajorderfunc = 'TrajOrder_AsImplementation_v1a';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'SysWrt_Name';
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
default{m,1}.labelstr = 'TrajOrderfunc';
default{m,1}.entrystr = trajorderfunc;
default{m,1}.searchpath = trajorderpath;
default{m,1}.path = [trajorderpath,trajorderfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtSysfunc';
default{m,1}.entrystr = wrtsysfunc;
default{m,1}.searchpath = wrtsyspath;
default{m,1}.path = [wrtsyspath,wrtsysfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'SystemWrite';
default{m,1}.labelstr = 'SystemWrite';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Write';

