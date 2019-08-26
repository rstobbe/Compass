%====================================================
%
%====================================================

function [default] = Implement_Proj3D_v1h_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    Nucpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\Nucleus Functions\'];
    ProjSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\ProjSamp Functions\TPI\'];
    TrajSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajSamp Functions\'];
    Syspath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\Sys Functions\'];
    ImpMethpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\ImpMeth Functions\'];
elseif strcmp(filesep,'/')
end
Nucfunc = 'Na23_v1a';
Sysfunc = 'Sys_SiemensPrisma_v1a';
ImpMethfunc = 'ImpMeth_QuantizedCATPI_v1a';
TrajSampfunc = 'TrajSamp_TPIstandard_v3b';
ProjSampfunc = 'ProjSamp_Cones_v1f';
Orient = 'Axial';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Imp_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Testing Only';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'No','Yes'};

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Des_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajDesCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'No';
default{m,1}.runfunc2 = 'LoadTrajDesDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'No';
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

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
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Orient';
default{m,1}.entrystr = Orient;
default{m,1}.options = {'Axial','Sagittal','Coronal'};

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
