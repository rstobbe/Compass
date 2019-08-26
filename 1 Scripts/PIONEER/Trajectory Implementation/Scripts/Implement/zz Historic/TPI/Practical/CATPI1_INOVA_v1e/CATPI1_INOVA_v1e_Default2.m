%====================================================
%
%====================================================

function [default] = CATPI1_INOVA_v1e_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Common']));
    ProjSamppath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\ProjSamp Functions\TPI\'];
    TrajSamppath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajSamp Functions\'];
    QVecSlvpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\QVecSlv Functions\'];
    GWFMpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\GWFM Functions\'];
    kSamppath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\1 ImCon Related\kSamp Functions\'];
    SysImppath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\SysImp Functions\'];
elseif strcmp(filesep,'/')
end
SysImpfunc = 'SysImp_InovaTPI_v1b';
QVecSlvfunc = 'QVecSlv_TPI_v2b';
GWFMfunc = 'GWFM_GSRA_v1e';
TrajSampfunc = 'TrajSamp_TPIstandard_v3b';
ProjSampfunc = 'ProjSamp_Cones_v1e';
kSampfunc = 'kSamp_TPISRI_v2m';

addpath([TrajSamppath,TrajSampfunc]);
addpath([ProjSamppath,ProjSampfunc]);
addpath([QVecSlvpath,QVecSlvfunc]);
addpath([GWFMpath,GWFMfunc]);
addpath([kSamppath,kSampfunc]);
addpath([SysImppath,SysImpfunc]);
System = 'Varian Inova';
SlvNo = '1000';
Orient = 'Axial';
iSeg = '0.3';

m = 1;
default{m,1}.entrytype = 'StatInput';
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
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'Yes';
default{m,1}.runfunc2 = 'LoadTrajDesDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'Yes';
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'System';
default{m,1}.entrystr = System;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Nucleus';
default{m,1}.entrystr = '23Na';
default{m,1}.options = {'1H','23Na'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SlvNo';
default{m,1}.entrystr = SlvNo;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Orient';
default{m,1}.entrystr = Orient;
default{m,1}.options = {'Axial','Sagittal','Coronal'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'iSeg (ms)';
default{m,1}.entrystr = iSeg;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SysImpfunc';
default{m,1}.entrystr = SysImpfunc;
default{m,1}.searchpath = SysImppath;
default{m,1}.path = [SysImppath,SysImpfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'QVecSlvfunc';
default{m,1}.entrystr = QVecSlvfunc;
default{m,1}.searchpath = QVecSlvpath;
default{m,1}.path = [QVecSlvpath,QVecSlvfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GWFMfunc';
default{m,1}.entrystr = GWFMfunc;
default{m,1}.searchpath = GWFMpath;
default{m,1}.path = [GWFMpath,GWFMfunc];

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
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'kSampfunc';
default{m,1}.entrystr = kSampfunc;
default{m,1}.searchpath = kSamppath;
default{m,1}.path = [kSamppath,kSampfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'TPI_Gen';
default{m,1}.labelstr = 'Implement';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
