%====================================================
%
%====================================================

function [default] = Implement_Proj3D_v1j_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    Testpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\Testing Functions\'];
    Nucpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\Nucleus Functions\'];
    ProjSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\ProjSamp Functions\TPI\'];
    TrajSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajSamp Functions\'];
    Syspath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajTest Functions\'];
    ImpMethpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\ImpMeth Functions\'];
elseif strcmp(filesep,'/')
end
Nucfunc = 'Na23_v1a';
Testfunc = 'TrajTest_Rapid_v1a';
Sysfunc = 'Sys_SiemensPrisma_v1a';
ImpMethfunc = 'ImpMeth_QuantizedCATPI_v1b';
TrajSampfunc = 'TrajSamp_SiemensLR_v3h';
ProjSampfunc = 'ProjSamp_Cones_v1f';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Imp_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Des_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajDesCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'No';
default{m,1}.runfunc2 = 'LoadTrajDesDisp';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'No';
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajTestfunc';
default{m,1}.entrystr = Testfunc;
default{m,1}.searchpath = Testpath;
default{m,1}.path = [Testpath,Testfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Sysfunc';
default{m,1}.entrystr = Sysfunc;
default{m,1}.searchpath = Syspath;
default{m,1}.path = [Syspath,Sysfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Nucfunc';
default{m,1}.entrystr = Nucfunc;
default{m,1}.searchpath = Nucpath;
default{m,1}.path = [Nucpath,Nucfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImpMethfunc';
default{m,1}.entrystr = ImpMethfunc;
default{m,1}.searchpath = ImpMethpath;
default{m,1}.path = [ImpMethpath,ImpMethfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajSampfunc';
default{m,1}.entrystr = TrajSampfunc;
default{m,1}.searchpath = TrajSamppath;
default{m,1}.path = [TrajSamppath,TrajSampfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ProjSampfunc';
default{m,1}.entrystr = ProjSampfunc;
default{m,1}.searchpath = ProjSamppath;
default{m,1}.path = [ProjSamppath,ProjSampfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'TPI_Gen';
default{m,1}.labelstr = 'Implement';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
