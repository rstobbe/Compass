%====================================================
%
%====================================================

function [default] = LR_INOVA_v1h_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    Nucpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\Nucleus Functions\'];
    ProjSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\ProjSamp Functions\LR\'];
    TrajSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajSamp Functions\'];
    QVecSlvpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\QVecSlv Functions\'];
    GWFMpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\GWFM Functions\'];
    kSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\1 ImCon Related\kSamp Functions\'];
    SysImppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\SysImp Functions\'];
    DEsoltimpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\LR\DEsoltim Functions\']; 
    accconstpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\LR\ConstEvol Functions\']; 
elseif strcmp(filesep,'/')
end
Nucfunc = 'H1_v1a';
SysImpfunc = 'SysImp_InovaLR_v1c';
QVecSlvfunc = 'QVecSlv_Even_v2b';
GWFMfunc = 'GWFM_LR1_v1a';
TrajSampfunc = 'TrajSamp_LRstandard_v3f';
ProjSampfunc = 'ProjSamp_Discs_v1b';
kSampfunc = 'kSamp_noECI_v2p';
DEsoltimfunc = 'DEst_LRMeth1_v1c';
accconstfunc = 'ConstEvol_v3c';

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
default{m,1}.labelstr = 'Nucfunc';
default{m,1}.entrystr = Nucfunc;
default{m,1}.searchpath = Nucpath;
default{m,1}.path = [Nucpath,Nucfunc];

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Orient';
default{m,1}.entrystr = 'Axial';
default{m,1}.options = {'Axial','Sagittal','Coronal'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SysImpfunc';
default{m,1}.entrystr = SysImpfunc;
default{m,1}.searchpath = SysImppath;
default{m,1}.path = [SysImppath,SysImpfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DeSolTimfunc';
default{m,1}.entrystr = DEsoltimfunc;
default{m,1}.searchpath = DEsoltimpath;
default{m,1}.path = [DEsoltimpath,DEsoltimfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ConstEvolfunc';
default{m,1}.entrystr = accconstfunc;
default{m,1}.searchpath = accconstpath;
default{m,1}.path = [accconstpath,accconstfunc];

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
default{m,1}.scrpttype = 'LR_Gen';
default{m,1}.labelstr = 'Implement';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
